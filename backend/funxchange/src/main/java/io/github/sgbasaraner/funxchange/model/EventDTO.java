package io.github.sgbasaraner.funxchange.model;

import java.time.LocalDateTime;

public class EventDTO {
    final String id;
    final String ownerId;
    final String type;
    final int capacity;
    final int participantCount;
    final String category;
    final String title;
    final String details;
    final double latitude;
    final double longitude;
    final String cityName;
    final String countryName;
    final long durationInMinutes;
    final LocalDateTime dateTime;
    final boolean joinable;

    public EventDTO(String id, String ownerId, String type, int capacity, int participantCount, String category, String title, String details, double latitude, double longitude, String cityName, String countryName, long durationInMinutes, LocalDateTime dateTime, boolean joinable) {
        this.id = id;
        this.ownerId = ownerId;
        this.type = type;
        this.capacity = capacity;
        this.participantCount = participantCount;
        this.category = category;
        this.title = title;
        this.details = details;
        this.latitude = latitude;
        this.longitude = longitude;
        this.cityName = cityName;
        this.countryName = countryName;
        this.durationInMinutes = durationInMinutes;
        this.dateTime = dateTime;
        this.joinable = joinable;
    }

    public String getId() {
        return id;
    }

    public String getOwnerId() {
        return ownerId;
    }

    public String getType() {
        return type;
    }

    public int getCapacity() {
        return capacity;
    }

    public int getParticipantCount() {
        return participantCount;
    }

    public String getCategory() {
        return category;
    }

    public String getTitle() {
        return title;
    }

    public String getDetails() {
        return details;
    }

    public double getLatitude() {
        return latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public String getCityName() {
        return cityName;
    }

    public String getCountryName() {
        return countryName;
    }

    public long getDurationInMinutes() {
        return durationInMinutes;
    }

    public LocalDateTime getDateTime() {
        return dateTime;
    }

    public boolean isJoinable() {
        return joinable;
    }
}
