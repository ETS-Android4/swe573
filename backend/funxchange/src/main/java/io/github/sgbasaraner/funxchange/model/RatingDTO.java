package io.github.sgbasaraner.funxchange.model;

public class RatingDTO {
    private final String id;
    private final UserDTO user;
    private final Integer rating;
    private final EventDTO event;

    public RatingDTO(String id, UserDTO user, Integer rating, EventDTO event) {
        this.id = id;
        this.user = user;
        this.rating = rating;
        this.event = event;
    }

    public UserDTO getUser() {
        return user;
    }

    public Integer getRating() {
        return rating;
    }

    public EventDTO getEvent() {
        return event;
    }

    public String getId() {
        return id;
    }
}
