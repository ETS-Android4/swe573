package io.github.sgbasaraner.funxchange.entity;

import javax.persistence.*;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Stream;

@Entity
@Table(name = "event")
public class Event {

    @Id
    @GeneratedValue
    private UUID id;

    @ManyToOne
    @JoinColumn(name="owner_id", nullable=false)
    private User user;

    @OneToMany(mappedBy="event")
    private Set<JoinRequest> joinRequests;

    @OneToMany(mappedBy="service")
    private Set<Rating> ratings;

    @Column
    private String type;

    @Column
    private int capacity;

    @Column
    private String category;

    @Column(columnDefinition = "TEXT")
    private String title;

    @Column(columnDefinition = "TEXT")
    private String details;

    @Column
    private double latitude;

    @Column
    private double longitude;

    @Column(columnDefinition = "TEXT")
    private String cityName;

    @Column(columnDefinition = "TEXT")
    private String countryName;

    @Column
    private LocalDateTime startDateTime;

    @Column
    private LocalDateTime endDateTime;

    @Column
    private LocalDateTime created;

    @ManyToMany(cascade = { CascadeType.PERSIST, CascadeType.MERGE })
    @JoinTable(
            name = "event_user",
            joinColumns = { @JoinColumn(name = "event_id") },
            inverseJoinColumns = { @JoinColumn(name = "user_id") }
    )
    private Set<User> participants;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public String getCityName() {
        return cityName;
    }

    public void setCityName(String cityName) {
        this.cityName = cityName;
    }

    public String getCountryName() {
        return countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    public LocalDateTime getStartDateTime() {
        return startDateTime;
    }

    public void setStartDateTime(LocalDateTime startDateTime) {
        this.startDateTime = startDateTime;
    }

    public LocalDateTime getEndDateTime() {
        return endDateTime;
    }

    public void setEndDateTime(LocalDateTime endDateTime) {
        this.endDateTime = endDateTime;
    }

    public LocalDateTime getCreated() {
        return created;
    }

    public void setCreated(LocalDateTime created) {
        this.created = created;
    }

    public Set<JoinRequest> getJoinRequests() {
        return joinRequests;
    }

    public void setJoinRequests(Set<JoinRequest> joinRequests) {
        this.joinRequests = joinRequests;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Set<User> getParticipants() {
        return participants;
    }

    public void setParticipants(Set<User> participants) {
        this.participants = participants;
    }

    public Set<Rating> getRatings() {
        return ratings;
    }

    public void setRatings(Set<Rating> ratings) {
        this.ratings = ratings;
    }

    public boolean isHandshaken(UUID userId) {
        if (!isEnded())
            return false;

        if (!getType().equals("service"))
            return false;

        return getUser().getId().equals(userId) ? isHandshakenForOrganizer() : isHandshakenForParticipant(userId);
    }

    private boolean isHandshakenForParticipant(UUID userId) {
        return findRatingsWhereRated(userId)
                .anyMatch(r -> r.getStatus() == Rating.RatingStatus.RATED);
    }

    private boolean isHandshakenForOrganizer() {
        return findRatingsWhereRated(getUser().getId())
                .anyMatch(r -> r.getStatus() == Rating.RatingStatus.RATED);
    }

    private Stream<Rating> findRatingsWhereRated(UUID ratedId) {
        return Optional
                .ofNullable(getRatings())
                .orElse(Collections.emptySet())
                .stream()
                .filter(r -> r.getRated().getId().equals(ratedId));
    }

    public boolean isInFuture() {
        return getStartDateTime().isAfter(LocalDateTime.now());
    }

    public boolean isEnded() {
        return getEndDateTime().isAfter(LocalDateTime.now());
    }

    public int getCreditValue() {
        return (int) Math.max(Math.abs(Duration.between(getStartDateTime(), getEndDateTime()).toHours()), 1);
    }
}
