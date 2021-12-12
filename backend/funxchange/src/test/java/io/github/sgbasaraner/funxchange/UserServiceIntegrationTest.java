package io.github.sgbasaraner.funxchange;

import io.github.sgbasaraner.funxchange.entity.Follower;
import io.github.sgbasaraner.funxchange.entity.Interest;
import io.github.sgbasaraner.funxchange.entity.User;
import io.github.sgbasaraner.funxchange.model.NewUserDTO;
import io.github.sgbasaraner.funxchange.model.UserDTO;
import io.github.sgbasaraner.funxchange.repository.FollowerRepository;
import io.github.sgbasaraner.funxchange.repository.InterestRepository;
import io.github.sgbasaraner.funxchange.repository.UserRepository;
import io.github.sgbasaraner.funxchange.service.UserDetailsServiceImpl;
import io.github.sgbasaraner.funxchange.service.UserService;
import io.github.sgbasaraner.funxchange.util.JwtUtil;
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

import java.util.List;
import java.util.Set;
import java.util.UUID;

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
    }

    @Autowired
    private UserService userService;

    @MockBean
    private UserRepository userRepository;

    @MockBean
    private InterestRepository interestRepository;

    @MockBean
    private FollowerRepository followRepository;

    @Test
    public void whenValidUser_thenUserShouldBeSaved() {
        User user = new User();
        user.setUserName("test");
        user.setBio("testbio");
        user.setId(UUID.randomUUID());
        final Interest interest = new Interest();
        interest.setName("Golf");
        user.setInterests(Set.of(interest));
        Mockito.when(userRepository.save(Mockito.any(User.class))).thenReturn(user);
        NewUserDTO newUserParams = new NewUserDTO(user.getUserName(), user.getBio(), List.of(interest.getName()), "somelongpassword");
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

        Mockito.verify(followRepository).delete(Mockito.any(Follower.class));
        final String followedUserId = userService.followUser(userToUnfollow.getId().toString(), currentUser::getUserName);
        Assertions.assertEquals(userToUnfollow.getId().toString(), followedUserId);
    }
}
