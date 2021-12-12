package io.github.sgbasaraner.funxchange.entity;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.ManyToAny;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Set;
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

    @ManyToMany(cascade = { CascadeType.PERSIST, CascadeType.MERGE })
    @JoinTable(
            name = "user_interest",
            joinColumns = { @JoinColumn(name = "user_id") },
            inverseJoinColumns = { @JoinColumn(name = "interest_id") }
    )
    private Set<Interest> interests;

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

    public Set<Interest> getInterests() {
        return interests;
    }

    public void setInterests(Set<Interest> interests) {
        this.interests = interests;
    }

    public void setCreated(LocalDateTime created) {
        this.created = created;
    }
}
