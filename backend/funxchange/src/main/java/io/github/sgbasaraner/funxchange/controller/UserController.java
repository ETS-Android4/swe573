package io.github.sgbasaraner.funxchange.controller;

import io.github.sgbasaraner.funxchange.model.AuthRequest;
import io.github.sgbasaraner.funxchange.model.AuthResponse;
import io.github.sgbasaraner.funxchange.model.NewUserDTO;
import io.github.sgbasaraner.funxchange.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import javax.security.sasl.AuthenticationException;
import java.security.Principal;

@RestController
public class UserController {

    @Autowired
    private UserService service;

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
        return "Hello, " + principal.getName() + ".";
    }
}
