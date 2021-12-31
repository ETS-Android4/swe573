package io.github.sgbasaraner.funxchange.model;

public class RatingDTO {
    private final UserDTO user;
    private final Integer rating;
    private final EventDTO event;

    public RatingDTO(UserDTO user, Integer rating, EventDTO event) {
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
}
