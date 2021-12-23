package io.github.sgbasaraner.funxchange.repository;

import io.github.sgbasaraner.funxchange.entity.Message;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface MessageRepository extends JpaRepository<Message, UUID> {
    @Query("select m from Message m where (m.senderId = ?1 and m.receiverId = ?2) or (m.senderId = ?2 and m.receiverId = ?1)")
    List<Message> findInConversation(UUID user1Id, UUID user2Id, Pageable page);

    List<Message> findBySenderIdOrReceiverId(UUID userId, UUID sameIdAgain);
}
