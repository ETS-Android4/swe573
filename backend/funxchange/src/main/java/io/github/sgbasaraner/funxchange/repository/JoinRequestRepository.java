package io.github.sgbasaraner.funxchange.repository;

import io.github.sgbasaraner.funxchange.entity.Event;
import io.github.sgbasaraner.funxchange.entity.JoinRequest;
import io.github.sgbasaraner.funxchange.entity.User;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.UUID;

public interface JoinRequestRepository extends JpaRepository<JoinRequest, UUID> {
    JoinRequest findFirstByEventAndUser(Event event, User user);

    @Query("select jr from JoinRequest jr where jr.event.user.id = ?1 and jr.event.startDateTime > current_timestamp")
    List<JoinRequest> findRequestsToUsers(UUID userId, Pageable page);
}
