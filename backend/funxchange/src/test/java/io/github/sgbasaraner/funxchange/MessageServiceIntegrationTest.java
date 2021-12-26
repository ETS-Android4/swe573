package io.github.sgbasaraner.funxchange;

import io.github.sgbasaraner.funxchange.entity.Message;
import io.github.sgbasaraner.funxchange.entity.User;
import io.github.sgbasaraner.funxchange.model.MessageDTO;
import io.github.sgbasaraner.funxchange.model.UserDTO;
import io.github.sgbasaraner.funxchange.repository.MessageRepository;
import io.github.sgbasaraner.funxchange.repository.UserRepository;
import io.github.sgbasaraner.funxchange.service.MessageService;
import io.github.sgbasaraner.funxchange.service.UserDetailsServiceImpl;
import io.github.sgbasaraner.funxchange.service.UserService;
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
import org.springframework.data.domain.Sort;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import javax.security.auth.Subject;
import java.security.Principal;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@ExtendWith(SpringExtension.class)
public class MessageServiceIntegrationTest {
    @TestConfiguration
    static class MessageServiceIntegrationTestContextConfiguration {
        @Bean
        public MessageService messageService() {
            return new MessageService();
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
        public Util util() {
            return new Util();
        }
    }

    @Autowired
    private MessageService messageService;

    @MockBean
    private UserRepository userRepository;

    @MockBean
    private MessageRepository messageRepository;

    @Autowired
    private Util util;

    class MockPrincipal implements Principal {

        public MockPrincipal(String name) {
            this.name = name;
        }

        final String name;

        @Override
        public String getName() {
            return name;
        }

        @Override
        public boolean implies(Subject subject) {
            return Principal.super.implies(subject);
        }
    }

    @Test
    public void whenQueriedByConversationId_serviceShouldFind() {
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
        Mockito.when(userRepository.getById(targetUser.getId())).thenReturn(targetUser);
        Mockito.when(userRepository.getById(currentUser.getId())).thenReturn(currentUser);

        final Message mockMessage = new Message();
        mockMessage.setText("test_text");
        mockMessage.setSenderId(currentUser.getId());
        mockMessage.setReceiverId(targetUser.getId());
        mockMessage.setCreated(LocalDateTime.now());

        Mockito.when(messageRepository.findInConversation(currentUser.getId(), targetUser.getId(), util.makePageable(0, 20, Sort.by("created").descending())))
                .thenReturn(List.of(mockMessage));

        final List<MessageDTO> foundMessages = messageService.fetchMessages(new MockPrincipal(currentUser.getUserName()), 0, 20, currentUser.getId().toString() + targetUser.getId().toString());
        Assertions.assertEquals(foundMessages.get(0).getText(), mockMessage.getText());
    }

    @Test
    public void whenAskedConversations_serviceShouldFind() {
        final User currentUser = new User();
        currentUser.setUserName("test_user");
        currentUser.setId(UUID.randomUUID());
        currentUser.setFollows(Collections.emptySet());

        final User targetUser = new User();
        targetUser.setUserName("target_user");
        targetUser.setId(UUID.randomUUID());
        targetUser.setFollows(Collections.emptySet());

        Mockito.when(userRepository.findUserByUserName(currentUser.getUserName())).thenReturn(Optional.of(currentUser));
        Mockito.when(userRepository.findUserByUserName(targetUser.getUserName())).thenReturn(Optional.of(targetUser));
        Mockito.when(userRepository.getById(targetUser.getId())).thenReturn(targetUser);
        Mockito.when(userRepository.getById(currentUser.getId())).thenReturn(currentUser);

        final Message mockMessage = new Message();
        mockMessage.setText("test_text");
        mockMessage.setSenderId(currentUser.getId());
        mockMessage.setReceiverId(targetUser.getId());
        mockMessage.setCreated(LocalDateTime.now());

        Mockito.when(messageRepository.findBySenderIdOrReceiverId(currentUser.getId(), currentUser.getId(), Sort.by("created").descending()))
                .thenReturn(List.of(mockMessage));

        final List<MessageDTO> foundMessages = messageService.fetchConversations(new MockPrincipal(currentUser.getUserName()), 0, 20);
        Assertions.assertEquals(foundMessages.get(0).getText(), mockMessage.getText());
    }
}
