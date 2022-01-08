package io.github.sgbasaraner.funxchange.service;

import io.github.sgbasaraner.funxchange.entity.*;
import io.github.sgbasaraner.funxchange.model.*;
import io.github.sgbasaraner.funxchange.repository.FollowerRepository;
import io.github.sgbasaraner.funxchange.repository.InterestRepository;
import io.github.sgbasaraner.funxchange.repository.UserRepository;
import io.github.sgbasaraner.funxchange.util.JwtUtil;
import io.github.sgbasaraner.funxchange.util.Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
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

    @Autowired
    private Util util;

    @Autowired
    private NotificationService notificationService;

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
        
        final Set<Interest> interests = new HashSet<>(interestRepository.findByNameIn(params.getInterests()));

        final String passwordHash = passwordEncoder.encode(params.getPassword());
        final User userEntity = new User();
        userEntity.setBio(params.getBio());
        userEntity.setPasswordHash(passwordHash);
        userEntity.setUserName(params.getUserName());
        userEntity.setInterests(interests);

        try {
            final User createdUser = repository.save(userEntity);
            return mapUserToDTO(createdUser, createdUser);
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

    public UserDTO fetchUser(String id, Principal principal) {
        final User loggedInUser = repository.findUserByUserName(principal.getName()).get();
        final Optional<User> userOption = repository.findById(UUID.fromString(id));
        if (userOption.isEmpty()) {
            throw new IllegalArgumentException("User doesn't exist.");
        }
        return mapUserToDTO(userOption.get(), loggedInUser);
    }

    UserDTO mapUserToDTO(User user, User requestor) {

        Optional<Boolean> isFollowed;
        CreditScore score = null;
        if (user.getId().equals(requestor.getId())) {
            isFollowed = Optional.empty();
            score = calculateCredits(user);
        } else if (requestor.getFollows().stream().anyMatch(f -> f.getFollowee().getId().equals(user.getId()))) {
            isFollowed = Optional.of(true);
        } else {
            isFollowed = Optional.of(false);
        }

        double ratingAvg = Optional
                .ofNullable(user.getRateds())
                .orElse(Collections.emptySet())
                .stream()
                .map(Rating::getRating)
                .filter(Objects::nonNull)
                .mapToDouble(r -> r)
                .average()
                .orElse(0);

        return new UserDTO(
                user.getId().toString(),
                user.getUserName(),
                user.getBio(),
                followerRepository.findByFollowee(user).size(),
                followerRepository.findByFollower(user).size(),
                user.getInterests().stream().map(Interest::getName).collect(Collectors.toUnmodifiableList()),
                isFollowed,
                score,
                ratingAvg);
    }

    public List<UserDTO> fetchFollowed(String id, int offset, int limit, Principal principal) {
        final User requestor = repository.findUserByUserName(principal.getName()).get();
        final Optional<User> targetUserOption = repository.findById(UUID.fromString(id));
        if (targetUserOption.isEmpty())
            throw new IllegalArgumentException("User doesn't exist.");

        final Pageable pageRequest = util.makePageable(offset, limit, Sort.by("created").descending());

        return followerRepository
                .findByFollower(targetUserOption.get(), pageRequest)
                .stream()
                .map(f -> mapUserToDTO(f.getFollowee(), requestor))
                .collect(Collectors.toUnmodifiableList());
    }

    public List<UserDTO> fetchFollowers(String id, int offset, int limit, Principal principal) {
        final User requestor = repository.findUserByUserName(principal.getName()).get();
        final Optional<User> targetUserOption = repository.findById(UUID.fromString(id));
        if (targetUserOption.isEmpty())
            throw new IllegalArgumentException("User doesn't exist.");

        final Pageable pageRequest = util.makePageable(offset, limit, Sort.by("created").descending());

        return followerRepository
                .findByFollowee(targetUserOption.get(), pageRequest)
                .stream()
                .map(f -> mapUserToDTO(f.getFollower(), requestor))
                .collect(Collectors.toUnmodifiableList());
    }

    @Transactional
    public String followUser(String userId, Principal principal) {
        final User loggedInUser = repository.findUserByUserName(principal.getName()).get();
        final Optional<User> followeeUserOption = repository.findById(UUID.fromString(userId));
        if (followeeUserOption.isEmpty())
            throw new IllegalArgumentException("User doesn't exist.");

        final User followeeUser = followeeUserOption.get();

        if (followerRepository.findByFolloweeAndFollower(followeeUser, loggedInUser).isPresent())
            throw new IllegalArgumentException("Already following.");

        final Follower f = new Follower();
        f.setFollower(loggedInUser);
        f.setFollowee(followeeUser);
        notificationService.sendNewFollowerNotification(f);
        followerRepository.save(f);
        return followeeUser.getId().toString();
    }

    @Transactional
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

    @Transactional
    public CreditScore calculateCredits(User user) {
        final int appliedScore = 5 + getGainedCredit(user) - getDeductedCredit(user);
        final int creditOnHold = getInProgressEventCredit(user)
                + getPendingJoinRequestCredits(user)
                + getParticipatedEventsWithPendingRating(user);
        return new CreditScore(appliedScore, creditOnHold);
    }

    private int getGainedCredit(User user) {
        return Optional
                .ofNullable(user.getEvents())
                .orElse(Collections.emptySet())
                .stream()
                .filter(e -> e.getType().equals("service"))
                .filter(e -> e.isHandshaken(user.getId()))
                .map(Event::getCreditValue)
                .reduce(0, Integer::sum);
    }

    private int getDeductedCredit(User user) {
        return Optional
                .ofNullable(user.getParticipatedEvents())
                .orElse(Collections.emptySet())
                .stream()
                .filter(e -> e.getType().equals("service"))
                .filter(e -> e.isHandshaken(user.getId()))
                .map(Event::getCreditValue)
                .reduce(0, Integer::sum);
    }

    private int getPendingJoinRequestCredits(User user) {
        return Optional
                .ofNullable(user.getJoinRequests())
                .orElse(Collections.emptySet())
                .stream()
                .map(JoinRequest::getEvent)
                .filter(e -> e.getType().equals("service"))
                .filter(Event::isInFuture)
                .map(Event::getCreditValue)
                .reduce(0, Integer::sum);
    }

    private int getInProgressEventCredit(User user) {
        return Optional
                .ofNullable(user.getParticipatedEvents())
                .orElse(Collections.emptySet())
                .stream()
                .filter(e -> e.getType().equals("service"))
                .filter(e -> !e.isEnded())
                .map(Event::getCreditValue)
                .reduce(0, Integer::sum);
    }

    private int getParticipatedEventsWithPendingRating(User user) {
        return Optional
                .ofNullable(user.getParticipatedEvents())
                .orElse(Collections.emptySet())
                .stream()
                .filter(e -> e.getType().equals("service"))
                .filter(Event::isEnded)
                .filter(e -> Optional
                        .ofNullable(e.getRatings())
                        .orElse(Collections.emptySet())
                        .stream()
                        .filter(r -> r.getRated().getId().equals(user.getId()))
                        .anyMatch(r -> r.getStatus() == Rating.RatingStatus.NOT_YET))
                .map(Event::getCreditValue)
                .reduce(0, Integer::sum);
    }

    public UserDTO fetchUserByUserName(String userName, Principal principal) {
        final User loggedInUser = repository.findUserByUserName(principal.getName()).get();
        final Optional<User> userOption = repository.findUserByUserName(userName);
        if (userOption.isEmpty())
            throw new IllegalArgumentException("User doesn't exist.");
        return mapUserToDTO(userOption.get(), loggedInUser);
    }

    public static final List<String> allowedInterests = List
            .of("Golf", "Yoga", "Painting", "Graphic Design", "Computers", "Makeup", "Cooking", "Gaming");

    private boolean areInterestsValid(List<String> interests) {
        final List<String> distinct = interests.stream().distinct().collect(Collectors.toUnmodifiableList());
        if (distinct.size() != interests.size()) return false;
        return allowedInterests.containsAll(distinct);
    }

    private boolean isUserNameValid(String userName) {
        return !(userName == null || userName.isBlank() || userName.length() < 3 || userName.length() > 31);
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
