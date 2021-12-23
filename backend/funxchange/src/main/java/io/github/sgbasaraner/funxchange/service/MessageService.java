package io.github.sgbasaraner.funxchange.service;

import io.github.sgbasaraner.funxchange.entity.Message;
import io.github.sgbasaraner.funxchange.entity.User;
import io.github.sgbasaraner.funxchange.model.MessageDTO;
import io.github.sgbasaraner.funxchange.model.NewMessageDTO;
import io.github.sgbasaraner.funxchange.repository.MessageRepository;
import io.github.sgbasaraner.funxchange.repository.UserRepository;
import io.github.sgbasaraner.funxchange.util.Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.Principal;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service
public class MessageService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private MessageRepository repository;

    @Autowired
    private Util util;

    public List<MessageDTO> fetchConversations(Principal principal, int offset, int limit) {
        final User requestor = userRepository.findUserByUserName(principal.getName()).get();
        final Set<String> convoIdSet = new HashSet<>();
        final List<Message> data = repository.findBySenderIdOrReceiverId(requestor.getId(), requestor.getId(), Sort.by("created").descending());
        final Map<UUID, User> userCache = new HashMap<>();

        return data.stream()
                .filter(message -> convoIdSet.add(makeConversationId(message.getSenderId(), message.getReceiverId())))
                .skip(offset)
                .limit(limit)
                .map(message -> {
                    final User senderUser = userCache.computeIfAbsent(message.getSenderId(), uuid -> userRepository.getById(uuid));
                    final User receiverUser = userCache.computeIfAbsent(message.getReceiverId(), uuid -> userRepository.getById(uuid));
                    return mapToMessageDTO(message, senderUser, receiverUser);
                })
                .collect(Collectors.toUnmodifiableList());
    }

    public List<MessageDTO> fetchMessages(Principal principal, int offset, int limit, String conversationId) {
        final Pageable pageRequest = util.makePageable(offset, limit, Sort.by("created").descending());
        final List<UUID> convoIdParsed = parseConversationId(conversationId);
        final User firstUser = userRepository.getById(convoIdParsed.get(0));
        final User secondUser = userRepository.getById(convoIdParsed.get(1));
        if (Stream.of(firstUser.getUserName(), secondUser.getUserName()).noneMatch(s -> s.equals(principal.getName()))) {
            throw new IllegalArgumentException("Invalid conversation");
        }

        return repository
                .findInConversation(convoIdParsed.get(0), convoIdParsed.get(1), pageRequest)
                .stream()
                .map(m -> {
                    final boolean isFirstUserSender = firstUser.getId().equals(m.getSenderId());
                    final User senderUser = isFirstUserSender ? firstUser : secondUser;
                    final User receiverUser = isFirstUserSender ? secondUser : firstUser;
                    return mapToMessageDTO(m, senderUser, receiverUser);
                })
                .collect(Collectors.toUnmodifiableList());
    }

    @Transactional
    public MessageDTO sendMessage(Principal principal, NewMessageDTO message) {
        final User requestor = userRepository.findUserByUserName(principal.getName()).get();
        final User receiver = userRepository.getById(UUID.fromString(message.getReceiverId()));
        final Message entity = new Message();
        entity.setText(message.getText());
        entity.setReceiverId(receiver.getId());
        entity.setSenderId(requestor.getId());
        final Message savedEntity = repository.save(entity);
        return mapToMessageDTO(savedEntity, requestor, receiver);
    }

    private MessageDTO mapToMessageDTO(Message message, User senderUser, User receiverUser) {
        return new MessageDTO(
                message.getSenderId().toString(),
                message.getReceiverId().toString(),
                makeConversationId(message.getSenderId(), message.getReceiverId()),
                senderUser.getUserName(),
                receiverUser.getUserName(),
                message.getText(),
                message.getCreated()
        );
    }

    private List<UUID> parseConversationId(String conversationId) {
        final int mid = conversationId.length() / 2;
        return Stream.of(conversationId.substring(0, mid), conversationId.substring(mid))
                .map(UUID::fromString)
                .collect(Collectors.toUnmodifiableList());
    }

    private String makeConversationId(UUID user1Id, UUID user2Id) {
        return Stream.of(user1Id, user2Id)
                .map(UUID::toString)
                .sorted()
                .collect(Collectors.joining());
    }
}
