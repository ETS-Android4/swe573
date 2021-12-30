package io.github.sgbasaraner.funxchange.controller;

import io.github.sgbasaraner.funxchange.model.AuthRequest;
import io.github.sgbasaraner.funxchange.model.AuthResponse;
import io.github.sgbasaraner.funxchange.repository.EventRepository;
import io.github.sgbasaraner.funxchange.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private EventRepository eventRepository;

    @PostMapping("/authenticate")
    public AuthResponse createAuthenticationToken(@RequestBody AuthRequest authenticationRequest) throws Exception {
        return userService.createAuthenticationToken(authenticationRequest);
    }
}
