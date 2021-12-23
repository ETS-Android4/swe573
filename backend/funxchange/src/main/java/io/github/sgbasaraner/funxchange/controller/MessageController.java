package io.github.sgbasaraner.funxchange.controller;

import io.github.sgbasaraner.funxchange.model.MessageDTO;
import io.github.sgbasaraner.funxchange.model.NewMessageDTO;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@RestController
public class MessageController {
    @GetMapping("/conversations")
    List<MessageDTO> fetchConversations(Principal principal, @RequestParam int offset, @RequestParam int limit) {
        return null;
    }

    @GetMapping("/conversations/{conversationId}/messages")
    List<MessageDTO> fetchMessages(Principal principal, @RequestParam int offset, @RequestParam int limit, @PathVariable String conversationId) {
        return null;
    }

    @PostMapping("/conversations")
    MessageDTO sendMessage(Principal principal, @RequestBody NewMessageDTO message) {
        return null;
    }
}
