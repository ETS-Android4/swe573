package io.github.sgbasaraner.funxchange.repository;

import io.github.sgbasaraner.funxchange.entity.Notification;
import io.github.sgbasaraner.funxchange.entity.User;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, UUID> {
    List<Notification> findByUser(User user, Pageable pageable);
}
