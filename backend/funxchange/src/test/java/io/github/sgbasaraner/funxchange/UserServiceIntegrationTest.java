package io.github.sgbasaraner.funxchange;

import io.github.sgbasaraner.funxchange.entity.User;
import io.github.sgbasaraner.funxchange.model.NewUserDTO;
import io.github.sgbasaraner.funxchange.model.UserDTO;
import io.github.sgbasaraner.funxchange.repository.UserRepository;
import io.github.sgbasaraner.funxchange.service.UserService;
import org.apache.commons.codec.digest.DigestUtils;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Bean;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.util.List;
import java.util.UUID;

@ExtendWith(SpringExtension.class)
public class UserServiceIntegrationTest {

    @TestConfiguration
    static class UserServiceIntegrationTestContextConfiguration {
        @Bean
        public UserService userService() {
            return new UserService();
        }
    }

    @Autowired
    private UserService userService;

    @MockBean
    private UserRepository userRepository;

    @Test
    public void whenValidUser_thenUserShouldBeSaved() {
        User user = new User();
        user.setUserName("test");
        user.setBio("testbio");
        user.setId(UUID.randomUUID());
        user.setPasswordHash(DigestUtils.sha256Hex("somelongpassword"));
        Mockito.when(userRepository.save(Mockito.any(User.class))).thenReturn(user);
        NewUserDTO newUserParams = new NewUserDTO(user.getUserName(), user.getBio(), List.of("test"), "somelongpassword");
        UserDTO createdUser = userService.signUp(newUserParams);
        Assertions.assertEquals(createdUser.getId(), user.getId().toString());
    }
}
