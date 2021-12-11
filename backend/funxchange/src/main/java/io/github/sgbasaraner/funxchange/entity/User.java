package io.github.sgbasaraner.funxchange.entity;

import org.hibernate.annotations.CreationTimestamp;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "fun_user")
public class User {
    @Id
    @GeneratedValue
    private UUID id;

    @Column(unique=true)
    private String userName;

    @Column
    private String passwordHash;

    @Column
    private String bio;

    @Column
    @CreationTimestamp
    private LocalDateTime created;

    public UUID getId() {
        return id;
    }

    public String getUserName() {
        return userName;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public String getBio() {
        return bio;
    }

    public LocalDateTime getCreated() {
        return created;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }
}
