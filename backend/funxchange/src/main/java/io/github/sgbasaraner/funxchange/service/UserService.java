package io.github.sgbasaraner.funxchange.service;

import io.github.sgbasaraner.funxchange.entity.Follower;
import io.github.sgbasaraner.funxchange.entity.Interest;
import io.github.sgbasaraner.funxchange.entity.User;
import io.github.sgbasaraner.funxchange.model.AuthRequest;
import io.github.sgbasaraner.funxchange.model.AuthResponse;
import io.github.sgbasaraner.funxchange.model.NewUserDTO;
import io.github.sgbasaraner.funxchange.model.UserDTO;
import io.github.sgbasaraner.funxchange.repository.FollowerRepository;
import io.github.sgbasaraner.funxchange.repository.InterestRepository;
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
import org.springframework.transaction.annotation.Transactional;

import javax.security.sasl.AuthenticationException;
import java.security.Principal;
import java.util.*;
import java.util.stream.Collectors;

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

    @Autowired
    private InterestRepository interestRepository;

    @Autowired
    private FollowerRepository followerRepository;

    @Transactional
    public UserDTO signUp(NewUserDTO params) {
        if (!isUserNameValid(params.getUserName()))
            throw new IllegalArgumentException("Invalid username.");

        if (!isBioValid(params.getBio()))
            throw new IllegalArgumentException("Invalid bio.");

        if (!isPasswordValid(params.getPassword()))
            throw new IllegalArgumentException("Password should consist of more than 4 characters.");

        if (!areInterestsValid(params.getInterests()))
            throw new IllegalArgumentException("Invalid interest list.");

        interestRepository.saveAll(params.getInterests().stream().map(i -> {
            final Interest interest = new Interest();
            interest.setName(i);
            return interest;
        }).collect(Collectors.toSet()));

        final Set<Interest> interests = new HashSet<>(interestRepository.findByNameIn(params.getInterests()));

        final String passwordHash = passwordEncoder.encode(params.getPassword());
        final User userEntity = new User();
        userEntity.setBio(params.getBio());
        userEntity.setPasswordHash(passwordHash);
        userEntity.setUserName(params.getUserName());
        userEntity.setInterests(interests);

        try {
            final User createdUser = repository.save(userEntity);
            return new UserDTO(
                    createdUser.getId().toString(),
                    createdUser.getUserName(),
                    createdUser.getBio(),
                    0,
                    0,
                    createdUser.getInterests().stream().map(Interest::getName).collect(Collectors.toUnmodifiableList()),
                    Optional.empty()
            );
        } catch (DataIntegrityViolationException e) {
            throw new IllegalArgumentException("Username already taken.");
        }
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

    public UserDTO fetchUser(String id) {
        return null;
    }

    public List<UserDTO> fetchFollowed(String id, Long offset, Long limit, Principal principal) {
        return null;
    }

    public List<UserDTO> fetchFollowers(String id, Long offset, Long limit, Principal principal) {
        return null;
    }

    public String followUser(String userId, Principal principal) {
        final User loggedInUser = repository.findUserByUserName(principal.getName()).get();
        final Optional<User> followeeUserOption = repository.findById(UUID.fromString(userId));
        if (followeeUserOption.isEmpty())
            throw new IllegalArgumentException("User doesn't exist.");

        final User followeeUser = followeeUserOption.get();

        final Follower f = new Follower();
        f.setFollower(loggedInUser);
        f.setFollowee(followeeUser);
        followerRepository.save(f);
        return followeeUser.getId().toString();
    }

    public String unfollowUser(String userId, Principal principal) {
        final User loggedInUser = repository.findUserByUserName(principal.getName()).get();
        final Optional<User> followeeUserOption = repository.findById(UUID.fromString(userId));
        if (followeeUserOption.isEmpty())
            throw new IllegalArgumentException("User doesn't exist.");

        final User followeeUser = followeeUserOption.get();

        Optional<Follower> f = followerRepository.findByFolloweeAndFollower(followeeUser, loggedInUser);
        if (f.isEmpty()) {
            throw new IllegalArgumentException("Follow relation doesn't exist.");
        }
        followerRepository.delete(f.get());
        return f.get().getFollowee().getId().toString();
    }

    public UserDTO fetchUserByUserName(String id) {
        return null;
    }

    private static final List<String> allowedInterests = List
            .of("Golf", "Yoga", "Painting", "Graphic Design", "Computers", "Makeup", "Cooking", "Gaming");

    private boolean areInterestsValid(List<String> interests) {
        final List<String> distinct = interests.stream().distinct().collect(Collectors.toUnmodifiableList());
        if (distinct.size() != interests.size()) return false;
        return allowedInterests.containsAll(distinct);
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
