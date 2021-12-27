package io.github.sgbasaraner.funxchange.repository;

import io.github.sgbasaraner.funxchange.entity.JoinRequest;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface JoinRequestRepository extends JpaRepository<JoinRequest, UUID> {
}
