package io.github.sgbasaraner.funxchange.entity;

import javax.persistence.*;

@Entity
@Table(name = "follower")
public class Follower {
    @Id
    @GeneratedValue
    private Long id;

    @ManyToOne
    @JoinColumn(name = "followee")
    private User followee;

    @ManyToOne
    @JoinColumn(name = "follower")
    private User follower;

    public User getFollowee() {
        return followee;
    }

    public void setFollowee(User followee) {
        this.followee = followee;
    }

    public User getFollower() {
        return follower;
    }

    public void setFollower(User follower) {
        this.follower = follower;
    }
}
