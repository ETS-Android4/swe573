package io.github.sgbasaraner.funxchange.repository;

import io.github.sgbasaraner.funxchange.entity.Event;
import io.github.sgbasaraner.funxchange.entity.JoinRequest;
import io.github.sgbasaraner.funxchange.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface JoinRequestRepository extends JpaRepository<JoinRequest, UUID> {
    JoinRequest findFirstByEventAndUser(Event event, User user);
}
