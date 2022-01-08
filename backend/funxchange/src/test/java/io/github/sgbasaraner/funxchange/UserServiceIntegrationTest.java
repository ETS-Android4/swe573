package io.github.sgbasaraner.funxchange;

import io.github.sgbasaraner.funxchange.entity.*;
import io.github.sgbasaraner.funxchange.model.NewUserDTO;
import io.github.sgbasaraner.funxchange.model.UserDTO;
import io.github.sgbasaraner.funxchange.repository.FollowerRepository;
import io.github.sgbasaraner.funxchange.repository.InterestRepository;
import io.github.sgbasaraner.funxchange.repository.NotificationRepository;
import io.github.sgbasaraner.funxchange.repository.UserRepository;
import io.github.sgbasaraner.funxchange.service.NotificationService;
import io.github.sgbasaraner.funxchange.service.UserDetailsServiceImpl;
import io.github.sgbasaraner.funxchange.service.UserService;
import io.github.sgbasaraner.funxchange.util.DeeplinkUtil;
import io.github.sgbasaraner.funxchange.util.JwtUtil;
import io.github.sgbasaraner.funxchange.util.Util;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Bean;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.time.LocalDateTime;
import java.util.*;

@ExtendWith(SpringExtension.class)
public class UserServiceIntegrationTest {

    @TestConfiguration
    static class UserServiceIntegrationTestContextConfiguration {
        @Bean
        public UserService userService() {
            return new UserService();
        }

        @Bean
        public PasswordEncoder passwordEncoder() {
            return new BCryptPasswordEncoder();
        }

        @Bean
        public AuthenticationManager authManager() {
            return authentication -> null;
        }

        @Bean
        public JwtUtil jwtUtil() {
            return new JwtUtil();
        }

        @Bean
        public UserDetailsService userDetailsService() {
            return new UserDetailsServiceImpl();
        }

        @Bean
        public NotificationService notificationService() {
            return new NotificationService();
        }

        @Bean
        public DeeplinkUtil deeplinkUtil() {
            return new DeeplinkUtil();
        }

        @Bean
        public Util util() {
            return new Util();
        }
    }

    @Autowired
    private UserService userService;

    @MockBean
    private UserRepository userRepository;

    @MockBean
    private InterestRepository interestRepository;

    @MockBean
    private FollowerRepository followRepository;

    @MockBean
    private NotificationRepository notificationRepository;

    @Test
    public void whenValidUser_thenUserShouldBeSaved() {
        User user = new User();
        user.setUserName("test");
        user.setBio("testbio");
        user.setId(UUID.randomUUID());
        user.setFollows(Collections.emptySet());
        final Interest interest = new Interest();
        interest.setName("Golf");
        user.setInterests(Set.of(interest));
        Mockito.when(userRepository.save(Mockito.any(User.class))).thenReturn(user);
        NewUserDTO newUserParams = new NewUserDTO(user.getUserName(), user.getBio(), List.of(interest.getName()), "somelongpassword");
        Mockito.when(followRepository.findByFollowee(Mockito.any(User.class))).thenReturn(Collections.emptyList());
        UserDTO createdUser = userService.signUp(newUserParams);
        Assertions.assertEquals(createdUser.getId(), user.getId().toString());
    }

    @Test
    public void whenFollowed_followShouldBeSaved() {
        final User currentUser = new User();
        currentUser.setUserName("test_user");
        currentUser.setId(UUID.randomUUID());


        final User userToFollow = new User();
        userToFollow.setUserName("followed_user");
        userToFollow.setId(UUID.randomUUID());

        final Follower followEntity = new Follower();
        followEntity.setFollower(currentUser);
        followEntity.setFollowee(userToFollow);

        Mockito.when(userRepository.findUserByUserName(currentUser.getUserName())).thenReturn(Optional.of(currentUser));
        Mockito.when(userRepository.findById(userToFollow.getId())).thenReturn(Optional.of(userToFollow));
        Mockito.when(followRepository.save(Mockito.any(Follower.class))).thenReturn(followEntity);
        final String followedUserId = userService.followUser(userToFollow.getId().toString(), currentUser::getUserName);
        Assertions.assertEquals(userToFollow.getId().toString(), followedUserId);
    }

    @Test
    public void whenUnfollowed_followShouldBeDeleted() {
        final User currentUser = new User();
        currentUser.setUserName("test_user");
        currentUser.setId(UUID.randomUUID());

        final User userToUnfollow = new User();
        userToUnfollow.setUserName("unfollowed_user");
        userToUnfollow.setId(UUID.randomUUID());

        final Follower followToDelete = new Follower();
        followToDelete.setFollowee(userToUnfollow);
        followToDelete.setFollower(currentUser);

        Mockito.when(userRepository.findUserByUserName(currentUser.getUserName())).thenReturn(Optional.of(currentUser));
        Mockito.when(userRepository.findById(userToUnfollow.getId())).thenReturn(Optional.of(userToUnfollow));
        Mockito.when(followRepository.findByFolloweeAndFollower(Mockito.any(User.class), Mockito.any(User.class))).thenReturn(Optional.of(followToDelete));
        final String followedUserId = userService.unfollowUser(userToUnfollow.getId().toString(), currentUser::getUserName);
        Mockito.verify(followRepository).delete(Mockito.any(Follower.class));
        Assertions.assertEquals(userToUnfollow.getId().toString(), followedUserId);
    }

    @Test
    public void whenQueriedByName_serviceShouldFind() {
        final User currentUser = new User();
        currentUser.setUserName("test_user");
        currentUser.setId(UUID.randomUUID());
        currentUser.setFollows(Collections.emptySet());

        final User targetUser = new User();
        targetUser.setUserName("target_user");
        targetUser.setId(UUID.randomUUID());
        targetUser.setFollows(Collections.emptySet());
        targetUser.setInterests(Collections.emptySet());

        Mockito.when(userRepository.findUserByUserName(currentUser.getUserName())).thenReturn(Optional.of(currentUser));
        Mockito.when(userRepository.findUserByUserName(targetUser.getUserName())).thenReturn(Optional.of(targetUser));
        Mockito.when(followRepository.findByFollowee(Mockito.any(User.class))).thenReturn(Collections.emptyList());

        final UserDTO foundUser = userService.fetchUserByUserName(targetUser.getUserName(), currentUser::getUserName);
        Assertions.assertEquals(foundUser.getId(), targetUser.getId().toString());
    }

    @Test
    public void whenQueriedById_serviceShouldFind() {
        final User currentUser = new User();
        currentUser.setUserName("test_user");
        currentUser.setId(UUID.randomUUID());
        currentUser.setFollows(Collections.emptySet());

        final User targetUser = new User();
        targetUser.setUserName("target_user");
        targetUser.setId(UUID.randomUUID());
        targetUser.setFollows(Collections.emptySet());
        targetUser.setInterests(Collections.emptySet());

        Mockito.when(userRepository.findUserByUserName(currentUser.getUserName())).thenReturn(Optional.of(currentUser));
        Mockito.when(userRepository.findById(targetUser.getId())).thenReturn(Optional.of(targetUser));
        Mockito.when(followRepository.findByFollowee(Mockito.any(User.class))).thenReturn(Collections.emptyList());

        final UserDTO foundUser = userService.fetchUser(targetUser.getId().toString(), currentUser::getUserName);

        Assertions.assertEquals(foundUser.getUserName(), targetUser.getUserName());
    }

    @Test
    public void whenAskedCreditsForHandshakenEvent_shouldComputeCorrectly() {
        var participantUser = new User();
        participantUser.setUserName("test_user");
        participantUser.setId(UUID.randomUUID());

        var organizerUser = new User();
        organizerUser.setUserName("org_user");
        organizerUser.setId(UUID.randomUUID());

        var handshakenPastEvent = new Event();
        handshakenPastEvent.setType("service");
        handshakenPastEvent.setUser(organizerUser);
        handshakenPastEvent.setStartDateTime(LocalDateTime.now().minusDays(5));
        handshakenPastEvent.setEndDateTime(handshakenPastEvent.getStartDateTime().plusHours(2));

        participantUser.setParticipatedEvents(Collections.singleton(handshakenPastEvent));
        organizerUser.setEvents(Collections.singleton(handshakenPastEvent));

        var participantRating = new Rating();
        participantRating.setId(UUID.randomUUID());
        participantRating.setRated(participantUser);
        participantRating.setRater(organizerUser);
        participantRating.setRating(1);

        var organizerRating = new Rating();
        organizerRating.setId(UUID.randomUUID());
        organizerRating.setRater(participantUser);
        organizerRating.setRated(organizerUser);
        organizerRating.setRating(1);

        handshakenPastEvent.setRatings(Set.of(participantRating, organizerRating));

        Assertions.assertEquals(7, userService.calculateCredits(organizerUser).getCredit());
        Assertions.assertEquals(3, userService.calculateCredits(participantUser).getCredit());
    }

    @Test
    public void whenAskedCreditsForNonHandshakenForParticipant_shouldComputeCorrectly() {
        var participantUser = new User();
        participantUser.setUserName("test_user");
        participantUser.setId(UUID.randomUUID());

        var organizerUser = new User();
        organizerUser.setUserName("org_user");
        organizerUser.setId(UUID.randomUUID());

        var handshakenPastEvent = new Event();
        handshakenPastEvent.setType("service");
        handshakenPastEvent.setUser(organizerUser);
        handshakenPastEvent.setStartDateTime(LocalDateTime.now().minusDays(5));
        handshakenPastEvent.setEndDateTime(handshakenPastEvent.getStartDateTime().plusHours(2));

        participantUser.setParticipatedEvents(Collections.singleton(handshakenPastEvent));
        organizerUser.setEvents(Collections.singleton(handshakenPastEvent));

        var participantRating = new Rating();
        participantRating.setId(UUID.randomUUID());
        participantRating.setRated(participantUser);
        participantRating.setRater(organizerUser);

        var organizerRating = new Rating();
        organizerRating.setId(UUID.randomUUID());
        organizerRating.setRater(participantUser);
        organizerRating.setRated(organizerUser);
        organizerRating.setRating(1);

        handshakenPastEvent.setRatings(Set.of(participantRating, organizerRating));

        Assertions.assertEquals(7, userService.calculateCredits(organizerUser).getCredit());
        Assertions.assertEquals(5, userService.calculateCredits(participantUser).getCredit());
    }

    @Test
    public void whenAskedCreditsForNonHandshakenForOrganizer_shouldComputeCorrectly() {
        var participantUser = new User();
        participantUser.setUserName("test_user");
        participantUser.setId(UUID.randomUUID());

        var organizerUser = new User();
        organizerUser.setUserName("org_user");
        organizerUser.setId(UUID.randomUUID());

        var nonHandshakenEvent = new Event();
        nonHandshakenEvent.setType("service");
        nonHandshakenEvent.setUser(organizerUser);
        nonHandshakenEvent.setStartDateTime(LocalDateTime.now().minusDays(5));
        nonHandshakenEvent.setEndDateTime(nonHandshakenEvent.getStartDateTime().plusHours(2));

        participantUser.setParticipatedEvents(Collections.singleton(nonHandshakenEvent));
        organizerUser.setEvents(Collections.singleton(nonHandshakenEvent));

        var participantRating = new Rating();
        participantRating.setId(UUID.randomUUID());
        participantRating.setRated(participantUser);
        participantRating.setRater(organizerUser);
        participantRating.setRating(1);

        var organizerRating = new Rating();
        organizerRating.setId(UUID.randomUUID());
        organizerRating.setRater(participantUser);
        organizerRating.setRated(organizerUser);


        nonHandshakenEvent.setRatings(Set.of(participantRating, organizerRating));

        Assertions.assertEquals(5, userService.calculateCredits(organizerUser).getCredit());
        Assertions.assertEquals(3, userService.calculateCredits(participantUser).getCredit());
    }

    @Test
    public void whenAskedOnHoldCreditsForPendingRatingForParticipant_shouldComputeCorrectly() {
        var participantUser = new User();
        participantUser.setUserName("test_user");
        participantUser.setId(UUID.randomUUID());

        var organizerUser = new User();
        organizerUser.setUserName("org_user");
        organizerUser.setId(UUID.randomUUID());

        var nonHandshakenEvent = new Event();
        nonHandshakenEvent.setType("service");
        nonHandshakenEvent.setUser(organizerUser);
        nonHandshakenEvent.setStartDateTime(LocalDateTime.now().minusDays(5));
        nonHandshakenEvent.setEndDateTime(nonHandshakenEvent.getStartDateTime().plusHours(2));

        participantUser.setParticipatedEvents(Collections.singleton(nonHandshakenEvent));
        organizerUser.setEvents(Collections.singleton(nonHandshakenEvent));

        var participantRating = new Rating();
        participantRating.setId(UUID.randomUUID());
        participantRating.setRated(participantUser);
        participantRating.setRater(organizerUser);

        var organizerRating = new Rating();
        organizerRating.setId(UUID.randomUUID());
        organizerRating.setRater(participantUser);
        organizerRating.setRated(organizerUser);
        organizerRating.setRating(1);

        nonHandshakenEvent.setRatings(Set.of(participantRating, organizerRating));

        Assertions.assertEquals(2, userService.calculateCredits(participantUser).getCreditOnHold());
    }

    @Test
    public void whenAskedOnHoldCreditsForFutureEvent_shouldComputeCorrectly() {
        var participantUser = new User();
        participantUser.setUserName("test_user");
        participantUser.setId(UUID.randomUUID());

        var organizerUser = new User();
        organizerUser.setUserName("org_user");
        organizerUser.setId(UUID.randomUUID());

        var futureEvent = new Event();
        futureEvent.setType("service");
        futureEvent.setUser(organizerUser);
        futureEvent.setStartDateTime(LocalDateTime.now().plusDays(5));
        futureEvent.setEndDateTime(futureEvent.getStartDateTime().plusHours(2));

        participantUser.setParticipatedEvents(Collections.singleton(futureEvent));
        organizerUser.setEvents(Collections.singleton(futureEvent));


        Assertions.assertEquals(2, userService.calculateCredits(participantUser).getCreditOnHold());
    }

    @Test
    public void whenAskedOnHoldCreditsForPendingJoinRequest_shouldComputeCorrectly() {
        var participantUser = new User();
        participantUser.setUserName("test_user");
        participantUser.setId(UUID.randomUUID());


        var organizerUser = new User();
        organizerUser.setUserName("org_user");
        organizerUser.setId(UUID.randomUUID());

        var futureEvent = new Event();
        futureEvent.setType("service");
        futureEvent.setUser(organizerUser);
        futureEvent.setStartDateTime(LocalDateTime.now().plusDays(5));
        futureEvent.setEndDateTime(futureEvent.getStartDateTime().plusHours(2));

        var joinRequest = new JoinRequest();
        joinRequest.setUser(participantUser);
        joinRequest.setEvent(futureEvent);

        participantUser.setJoinRequests(Collections.singleton(joinRequest));

        organizerUser.setEvents(Collections.singleton(futureEvent));

        Assertions.assertEquals(2, userService.calculateCredits(participantUser).getCreditOnHold());
    }
}
