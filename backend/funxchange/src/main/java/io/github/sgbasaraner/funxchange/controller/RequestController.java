package io.github.sgbasaraner.funxchange.controller;

import io.github.sgbasaraner.funxchange.model.JoinRequestDTO;
import io.github.sgbasaraner.funxchange.service.EventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;
import java.util.List;

@RestController
public class RequestController {

    @Autowired
    private EventService eventService;

    @GetMapping("/requests")
    List<JoinRequestDTO> fetchRequests(Principal principal, @RequestParam int offset, @RequestParam int limit) {
        return eventService.fetchRequests(principal, offset, limit);
    }
}
