package io.github.sgbasaraner.funxchange.service;

import io.github.sgbasaraner.funxchange.entity.User;
import io.github.sgbasaraner.funxchange.model.AuthRequest;
import io.github.sgbasaraner.funxchange.model.AuthResponse;
import io.github.sgbasaraner.funxchange.model.NewUserDTO;
import io.github.sgbasaraner.funxchange.model.UserDTO;
import io.github.sgbasaraner.funxchange.repository.UserRepository;
import io.github.sgbasaraner.funxchange.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import javax.security.sasl.AuthenticationException;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository repository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtUtil jwtTokenUtil;

    @Autowired
    private UserDetailsService userDetailsService;

    public UserDTO signUp(NewUserDTO params) {
        if (!isUserNameValid(params.getUserName()))
            throw new IllegalArgumentException("Invalid username.");

        if (!isBioValid(params.getBio()))
            throw new IllegalArgumentException("Invalid bio.");

        if (!isPasswordValid(params.getPassword()))
            throw new IllegalArgumentException("Password should consist of more than 4 characters.");

        final String passwordHash = passwordEncoder.encode(params.getPassword());
        final User userEntity = new User();
        userEntity.setBio(params.getBio());
        userEntity.setPasswordHash(passwordHash);
        userEntity.setUserName(params.getUserName());

        try {
            final User createdUser = repository.save(userEntity);
            return new UserDTO(createdUser.getId().toString(), createdUser.getUserName(), createdUser.getBio(), 0,0, params.getInterests(), Optional.empty());
        } catch (DataIntegrityViolationException e) {
            throw new IllegalArgumentException("Username already taken.");
        }


        // TODO: save interests


    }

    public AuthResponse createAuthenticationToken(AuthRequest authenticationRequest) throws AuthenticationException {
        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(authenticationRequest.getUserName(), authenticationRequest.getPassword())
            );
        }
        catch (BadCredentialsException e) {
            throw new AuthenticationException();
        }


        final UserDetails userDetails = userDetailsService.loadUserByUsername(authenticationRequest.getUserName());

        final String jwt = jwtTokenUtil.generateToken(userDetails);

        return new AuthResponse(jwt);
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
