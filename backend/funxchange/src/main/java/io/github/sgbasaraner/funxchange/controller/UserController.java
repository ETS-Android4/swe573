package io.github.sgbasaraner.funxchange.controller;

import io.github.sgbasaraner.funxchange.model.NewUserDTO;
import io.github.sgbasaraner.funxchange.model.UserDTO;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class UserController {

    @PostMapping("/signup")
    public ResponseEntity<UserDTO> signUp(@RequestBody NewUserDTO params) {
        return null;
    }
}
