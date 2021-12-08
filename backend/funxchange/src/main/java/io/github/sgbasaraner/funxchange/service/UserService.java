package io.github.sgbasaraner.funxchange.service;

import io.github.sgbasaraner.funxchange.model.NewUserDTO;
import io.github.sgbasaraner.funxchange.model.UserDTO;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {
    public UserDTO signUp(NewUserDTO params) {
        return new UserDTO("", params.getUserName(), params.getBio(), 0,0, params.getInterests(), Optional.empty());
    }
}
