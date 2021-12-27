package io.github.sgbasaraner.funxchange.model;

public class JoinRequestDTO {
    final String eventId;
    final String userId;
    final String htmlText;

    public JoinRequestDTO(String eventId, String userId, String htmlText) {
        this.eventId = eventId;
        this.userId = userId;
        this.htmlText = htmlText;
    }

    public String getEventId() {
        return eventId;
    }

    public String getUserId() {
        return userId;
    }

    public String getHtmlText() {
        return htmlText;
    }
}
