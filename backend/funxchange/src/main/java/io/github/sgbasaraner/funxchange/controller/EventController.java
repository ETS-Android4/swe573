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
    ResponseEntity<EventDTO> fetchEvent(Principal principal, @PathVariable String eventId) {
        try {
            return ResponseEntity.ok(eventService.fetchEvent(eventId));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/events/feed")
    ResponseEntity<List<EventDTO>> fetchFeed(Principal principal, @RequestParam int offset, @RequestParam int limit) {
        try {
            return ResponseEntity.ok(eventService.fetchFeed(offset, limit));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/user/{userId}/events")
    ResponseEntity<List<EventDTO>> fetchEventsOfUser(Principal principal, @RequestParam int offset, @RequestParam int limit, @PathVariable String userId) {
        try {
            return ResponseEntity.ok(eventService.fetchEventsOfUser(offset, limit, userId));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/events/{eventId}/participants")
    ResponseEntity<List<UserDTO>> fetchParticipantsOfEvent(Principal principal, @PathVariable String eventId) {
        try {
            return ResponseEntity.ok(eventService.fetchParticipantsOfEvent(principal, eventId));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
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
    ResponseEntity<JoinRequestDTO> joinEvent(Principal principal, @PathVariable String eventId) {
        try {
            return ResponseEntity.ok(eventService.joinEvent(principal, eventId));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping("/events/{eventId}/requestors/{userId}/accept")
    ResponseEntity<JoinRequestDTO> acceptJoinRequest(Principal principal, @PathVariable String eventId, @PathVariable String userId) {
        try {
            return ResponseEntity.ok(eventService.acceptJoinRequest(principal, eventId, userId));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping("/events/{eventId}/requestors/{userId}/reject")
    ResponseEntity<JoinRequestDTO> rejectJoinRequest(Principal principal, @PathVariable String eventId, @PathVariable String userId) {
        try {
            return ResponseEntity.ok(eventService.rejectJoinRequest(principal, eventId, userId));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
    }
}
