package io.github.sgbasaraner.funxchange.service;

import io.github.sgbasaraner.funxchange.entity.User;
import io.github.sgbasaraner.funxchange.model.NewUserDTO;
import io.github.sgbasaraner.funxchange.model.UserDTO;
import io.github.sgbasaraner.funxchange.repository.UserRepository;
import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository repository;


    public UserDTO signUp(NewUserDTO params) {
        if (!isUserNameValid(params.getUserName()))
            throw new IllegalArgumentException("Invalid username.");

        if (!isBioValid(params.getBio()))
            throw new IllegalArgumentException("Invalid bio.");

        if (!isPasswordValid(params.getPassword()))
            throw new IllegalArgumentException("Password should consist of more than 4 characters.");

        // TODO: check if username is being used

        final String passwordHash = DigestUtils.sha256Hex(params.getPassword());
        final User userEntity = new User();
        userEntity.setBio(params.getBio());
        userEntity.setPasswordHash(passwordHash);
        userEntity.setUserName(params.getUserName());

        final User createdUser = repository.save(userEntity);

        // TODO: save interests

        return new UserDTO(createdUser.getId().toString(), createdUser.getUserName(), createdUser.getBio(), 0,0, params.getInterests(), Optional.empty());
    }

    private boolean isUserNameValid(String userName) {
        return !(userName == null || userName.isBlank() || userName.length() < 3);
    }

    private boolean isBioValid(String bio) {
        if (bio == null) return false;
        return bio.length() < 1024;
    }

    private boolean isPasswordValid(String password) {
        if (password == null) return false;
        return password.length() > 4 && password.length() < 1024;
    }
}
