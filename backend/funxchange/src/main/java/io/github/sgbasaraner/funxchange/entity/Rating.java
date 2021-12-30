package io.github.sgbasaraner.funxchange.entity;

import javax.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "rating")
public class Rating {
    @Id
    @GeneratedValue
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "rater")
    private User rater;

    @ManyToOne
    @JoinColumn(name = "service")
    private Event service;

    @Column
    private Integer rating;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public User getRater() {
        return rater;
    }

    public void setRater(User rater) {
        this.rater = rater;
    }

    public Event getService() {
        return service;
    }

    public void setService(Event service) {
        this.service = service;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }
}
