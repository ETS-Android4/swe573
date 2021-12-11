package io.github.sgbasaraner.funxchange.service;

import io.github.sgbasaraner.funxchange.entity.User;
import io.github.sgbasaraner.funxchange.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class AuthService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        final Optional<User> user = userRepository.findUserByUserName(username);
        if (user.isEmpty()) throw new UsernameNotFoundException("User not found.");
        return new org.springframework.security.core.userdetails.User(user.get().getUserName(), user.get().getPasswordHash(), List.of());
    }
}
