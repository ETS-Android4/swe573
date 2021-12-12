package io.github.sgbasaraner.funxchange.repository;


import io.github.sgbasaraner.funxchange.entity.Interest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface InterestRepository extends JpaRepository<Interest, String> {
    List<Interest> findByNameIn(List<String> names);
}
