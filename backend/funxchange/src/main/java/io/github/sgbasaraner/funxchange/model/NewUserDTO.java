package io.github.sgbasaraner.funxchange.model;

import java.util.List;

public class NewUserDTO {
    private final String userName;
    private final String bio;
    private final List<String> interests;
    private final String password;

    public NewUserDTO(String userName, String bio, List<String> interests, String password) {
        this.userName = userName;
        this.bio = bio;
        this.interests = interests;
        this.password = password;
    }

    public String getUserName() {
        return userName;
    }

    public String getBio() {
        return bio;
    }

    public List<String> getInterests() {
        return interests;
    }

    public String getPassword() {
        return password;
    }

}
