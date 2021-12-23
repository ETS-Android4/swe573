package io.github.sgbasaraner.funxchange.controller;

import io.github.sgbasaraner.funxchange.model.MessageDTO;
import io.github.sgbasaraner.funxchange.model.NewMessageDTO;
import io.github.sgbasaraner.funxchange.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@RestController
public class MessageController {

    @Autowired
    private MessageService service;

    @GetMapping("/conversations")
    List<MessageDTO> fetchConversations(Principal principal, @RequestParam int offset, @RequestParam int limit) {
        return service.fetchConversations(principal, offset, limit);
    }

    @GetMapping("/conversations/{conversationId}/messages")
    List<MessageDTO> fetchMessages(Principal principal, @RequestParam int offset, @RequestParam int limit, @PathVariable String conversationId) {
        return service.fetchMessages(principal, offset, limit, conversationId);
    }

    @PostMapping("/conversations")
    MessageDTO sendMessage(Principal principal, @RequestBody NewMessageDTO message) {
        return service.sendMessage(principal, message);
    }
}
