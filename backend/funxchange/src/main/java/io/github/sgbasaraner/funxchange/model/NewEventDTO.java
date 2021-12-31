package io.github.sgbasaraner.funxchange.model;

import java.time.LocalDateTime;

public class NewEventDTO {
    final String type;
    final int capacity;
    final String category;
    final String title;
    final String details;
    final double latitude;
    final double longitude;
    final String cityName;
    final String countryName;
    final LocalDateTime endDateTime;
    final LocalDateTime startDateTime;

    public NewEventDTO(String type, int capacity, String category, String title, String details, double latitude, double longitude, String cityName, String countryName, LocalDateTime endDateTime, LocalDateTime startDateTime) {
        this.type = type;
        this.capacity = capacity;
        this.category = category;
        this.title = title;
        this.details = details;
        this.latitude = latitude;
        this.longitude = longitude;
        this.cityName = cityName;
        this.countryName = countryName;
        this.endDateTime = endDateTime;
        this.startDateTime = startDateTime;
    }

    public String getType() {
        return type;
    }

    public int getCapacity() {
        return capacity;
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

    public LocalDateTime getEndDateTime() {
        return endDateTime;
    }

    public LocalDateTime getStartDateTime() {
        return startDateTime;
    }
}
