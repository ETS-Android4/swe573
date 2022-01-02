package io.github.sgbasaraner.funxchange.controller;

import io.github.sgbasaraner.funxchange.model.AuthRequest;
import io.github.sgbasaraner.funxchange.model.AuthResponse;
import io.github.sgbasaraner.funxchange.model.NewUserDTO;
import io.github.sgbasaraner.funxchange.model.UserDTO;
import io.github.sgbasaraner.funxchange.repository.EventRepository;
import io.github.sgbasaraner.funxchange.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import javax.security.sasl.AuthenticationException;
import java.security.Principal;
import java.util.List;

@RestController
public class UserController {

    @Autowired
    private UserService service;

    @Autowired
    private EventRepository eventRepository;

    @PostMapping("/signup")
    public ResponseEntity<AuthResponse> signUp(@RequestBody NewUserDTO params) {
        try {
            service.signUp(params);
            return ResponseEntity.ok(service.createAuthenticationToken(new AuthRequest(params.getUserName(), params.getPassword())));
        } catch (IllegalArgumentException | DuplicateKeyException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getLocalizedMessage());
        } catch (AuthenticationException e) {
            throw new IllegalStateException();
        }
    }

    @GetMapping("/hello")
    public String hello(Principal principal) {
        return "Hi there, " + principal.getName() + ". We have a total of " + eventRepository.count() + " events.";
    }

    @GetMapping("/user/{userId}/followers")
    public List<UserDTO> getFollowers(Principal principal, @RequestParam int offset, @RequestParam int limit, @PathVariable String userId) {
        try {
            return service.fetchFollowers(userId, offset, limit, principal);
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getLocalizedMessage());
        }
    }

    @GetMapping("/user/{userId}/followees")
    public List<UserDTO> getFollowees(Principal principal, @RequestParam int offset, @RequestParam int limit, @PathVariable String userId) {
        try {
            return service.fetchFollowed(userId, offset, limit, principal);
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getLocalizedMessage());
        }
    }

    @GetMapping("/user/{userId}")
    public UserDTO fetchUser(Principal principal, @PathVariable String userId) {
        try {
            if (userId.length() == 36) {
                return service.fetchUser(userId, principal);
            } else {
                return service.fetchUserByUserName(userId, principal);
            }
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getLocalizedMessage());
        }
    }

    @PostMapping("/user/{targetUser}/followers")
    public String followUser(Principal principal, @PathVariable String targetUser) {
        try {
            return service.followUser(targetUser, principal);
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getLocalizedMessage());
        }
    }

    @DeleteMapping("/user/{targetUser}/followers")
    public String unfollowUser(Principal principal, @PathVariable String targetUser) {
        try {
            return service.unfollowUser(targetUser, principal);
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getLocalizedMessage());
        }
    }
}
