package io.github.sgbasaraner.funxchange.model;

import java.util.List;
import java.util.Optional;

public class UserDTO {
    private final String id;
    private final String userName;
    private final String bio;
    private final int followerCount;
    private final int followedCount;
    private final List<String> interests;
    private final Optional<Boolean> isFollowed;

    public UserDTO(String id, String userName, String bio, int followerCount, int followedCount, List<String> interests, Optional<Boolean> isFollowed) {
        this.id = id;
        this.userName = userName;
        this.bio = bio;
        this.followerCount = followerCount;
        this.followedCount = followedCount;
        this.interests = interests;
        this.isFollowed = isFollowed;
    }

    public String getId() {
        return id;
    }

    public String getUserName() {
        return userName;
    }

    public String getBio() {
        return bio;
    }

    public int getFollowerCount() {
        return followerCount;
    }

    public int getFollowedCount() {
        return followedCount;
    }

    public List<String> getInterests() {
        return interests;
    }

    public Optional<Boolean> getIsFollowed() {
        return isFollowed;
    }
}
