package io.github.sgbasaraner.funxchange.entity;

import org.hibernate.annotations.CreationTimestamp;

import javax.persistence.*;
import java.time.LocalDateTime;
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
    @JoinColumn(name = "rated")
    private User rated;

    @ManyToOne
    @JoinColumn(name = "service")
    private Event service;

    @Column
    private Integer rating;

    @Column
    @CreationTimestamp
    private LocalDateTime created;

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

    public LocalDateTime getCreated() {
        return created;
    }

    public void setCreated(LocalDateTime created) {
        this.created = created;
    }

    public User getRated() {
        return rated;
    }

    public void setRated(User rated) {
        this.rated = rated;
    }

    enum RatingStatus {
        NOT_YET, NO_SHOW, RATED
    }

    public RatingStatus getStatus() {
        var rating = getRating();
        if (rating == null) {
            return RatingStatus.NOT_YET;
        }

        if (rating == 0) {
            return RatingStatus.NO_SHOW;
        }

        return RatingStatus.RATED;
    }
}
