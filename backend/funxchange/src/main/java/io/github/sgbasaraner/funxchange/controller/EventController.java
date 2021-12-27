package io.github.sgbasaraner.funxchange.controller;

import io.github.sgbasaraner.funxchange.model.EventDTO;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;
import java.util.List;

@RestController
public class EventController {
    @GetMapping("/events/{eventId}")
    EventDTO fetchEvent(Principal principal, @PathVariable String eventId) {
        return null;
    }

    @GetMapping("/events/feed")
    List<EventDTO> fetchFeed(Principal principal, @RequestParam int offset, @RequestParam int limit) {
        return null;
    }
}
