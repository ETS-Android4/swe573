package io.github.sgbasaraner.funxchange.util;

import io.github.sgbasaraner.funxchange.entity.Event;
import io.github.sgbasaraner.funxchange.entity.User;
import org.springframework.stereotype.Component;

import java.util.UUID;

@Component
public class DeeplinkUtil {
    static private final String baseDeeplink = "funxchange://";

    static public final String requestsDeeplink = baseDeeplink + "requests";

    public String generateUserDeeplink(UUID userId) {
        return baseDeeplink + "users/" + userId.toString();
    }

    public String generateEventDeeplink(UUID eventId) {
        return baseDeeplink + "events/" + eventId.toString();
    }

    public String generateUserHtml(User user) {
        final String deeplink = generateUserDeeplink(user.getId());
        return "<a href=\"" + deeplink + "\">" + user.getUserName() + "</a>";
    }

    public String generateEventHtml(Event event) {
        final String deeplink = generateEventDeeplink(event.getId());
        return "<a href=\"" + deeplink + "\">" + event.getTitle() + "</a>";
    }
}
