package io.github.sgbasaraner.funxchange.repository;

import io.github.sgbasaraner.funxchange.entity.Follower;
import io.github.sgbasaraner.funxchange.entity.User;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


import java.util.List;
import java.util.Optional;

@Repository
public interface FollowerRepository extends JpaRepository<Follower, Long> {
    Optional<Follower> findByFolloweeAndFollower(User followee, User follower);
    List<Follower> findByFollowee(User followee);
    List<Follower> findByFollowee(User followee, Pageable pageable);
    List<Follower> findByFollower(User follower, Pageable pageable);
    List<Follower> findByFollower(User follower);
}
