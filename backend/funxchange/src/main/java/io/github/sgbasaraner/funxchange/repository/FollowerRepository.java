package io.github.sgbasaraner.funxchange.repository;

import io.github.sgbasaraner.funxchange.entity.Follower;
import io.github.sgbasaraner.funxchange.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface FollowerRepository extends JpaRepository<Follower, Long> {
    Optional<Follower> findByFolloweeAndFollower(User followee, User follower);
}
