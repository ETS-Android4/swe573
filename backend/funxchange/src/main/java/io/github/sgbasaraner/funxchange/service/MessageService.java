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

import java.security.Principal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
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

    List<MessageDTO> fetchConversations(Principal principal, int offset, int limit) {
        return null;
    }

    List<MessageDTO> fetchMessages(Principal principal, int offset, int limit, String conversationId) {
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

    MessageDTO sendMessage(Principal principal, NewMessageDTO message) {
        return null;
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
        final int mid = conversationId.length();
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
