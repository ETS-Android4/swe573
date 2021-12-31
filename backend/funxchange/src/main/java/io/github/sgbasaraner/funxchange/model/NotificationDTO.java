package io.github.sgbasaraner.funxchange.model;

public class NotificationDTO {
    final String htmlText;
    final String deeplink;

    public NotificationDTO(String htmlText, String deeplink) {
        this.htmlText = htmlText;
        this.deeplink = deeplink;
    }

    public String getHtmlText() {
        return htmlText;
    }

    public String getDeeplink() {
        return deeplink;
    }
}
