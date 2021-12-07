package io.github.sgbasaraner.funxchange.repository;

import io.github.sgbasaraner.funxchange.entity.Test;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TestRepository extends JpaRepository<Test, Long> {
}
