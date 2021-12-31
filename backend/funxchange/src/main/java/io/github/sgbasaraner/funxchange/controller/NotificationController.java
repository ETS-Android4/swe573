package io.github.sgbasaraner.funxchange.controller;

import io.github.sgbasaraner.funxchange.model.NotificationDTO;
import io.github.sgbasaraner.funxchange.service.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;
import java.util.List;

@RestController
public class NotificationController {

    @Autowired
    private NotificationService notificationService;

    @GetMapping("/notifications")
    List<NotificationDTO> fetchNotifications(Principal principal, @RequestParam int offset, @RequestParam int limit) {
        return notificationService.fetchNotifications(principal, offset, limit);
    }
}
