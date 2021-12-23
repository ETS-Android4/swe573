package io.github.sgbasaraner.funxchange.service;

import io.github.sgbasaraner.funxchange.model.MessageDTO;
import io.github.sgbasaraner.funxchange.model.NewMessageDTO;
import io.github.sgbasaraner.funxchange.repository.MessageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.security.Principal;
import java.util.List;

@Service
public class MessageService {

    @Autowired
    MessageRepository repository;

    List<MessageDTO> fetchConversations(Principal principal, int offset, int limit) {
        return null;
    }

    List<MessageDTO> fetchMessages(Principal principal, int offset, int limit, String conversationId) {
        return null;
    }

    MessageDTO sendMessage(Principal principal, NewMessageDTO message) {
        return null;
    }
}
