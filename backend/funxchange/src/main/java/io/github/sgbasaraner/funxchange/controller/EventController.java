package io.github.sgbasaraner.funxchange.controller;

import io.github.sgbasaraner.funxchange.model.EventDTO;
import io.github.sgbasaraner.funxchange.model.JoinRequestDTO;
import io.github.sgbasaraner.funxchange.model.NewEventDTO;
import io.github.sgbasaraner.funxchange.model.UserDTO;
import io.github.sgbasaraner.funxchange.service.EventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@RestController
public class EventController {

    @Autowired
    private EventService eventService;

    @GetMapping("/events/{eventId}")
    EventDTO fetchEvent(Principal principal, @PathVariable String eventId) {
        return null;
    }

    @GetMapping("/events/feed")
    List<EventDTO> fetchFeed(Principal principal, @RequestParam int offset, @RequestParam int limit) {
        return null;
    }

    @GetMapping("/user/{userId}/events")
    List<EventDTO> fetchEventsOfUser(Principal principal, @RequestParam int offset, @RequestParam int limit, @PathVariable String userId) {
        return null;
    }

    @GetMapping("/events/{eventId}/participants")
    List<UserDTO> fetchParticipantsOfEvent(Principal principal, @PathVariable String eventId) {
        return null;
    }

    @PostMapping("/events")
    ResponseEntity<EventDTO> createEvent(Principal principal, @RequestBody NewEventDTO params) {
        try {
            return ResponseEntity.ok(eventService.createEvent(principal, params));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping("/events/{eventId}/join")
    JoinRequestDTO joinEvent(Principal principal, @PathVariable String eventId) {
        return null;
    }

    @PostMapping("/events/{eventId}/requestors/{userId}/accept")
    JoinRequestDTO acceptJoinRequest(Principal principal, @PathVariable String eventId, @PathVariable String userId) {
        return null;
    }

    @PostMapping("/events/{eventId}/requestors/{userId}/reject")
    JoinRequestDTO rejectJoinRequest(Principal principal, @PathVariable String eventId, @PathVariable String userId) {
        return null;
    }
}
