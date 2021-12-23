package io.github.sgbasaraner.funxchange.model;

public class NewMessageDTO {
    final String text;
    final String receiverId;

    public NewMessageDTO(String text, String receiverId) {
        this.text = text;
        this.receiverId = receiverId;
    }

    public String getText() {
        return text;
    }

    public String getReceiverId() {
        return receiverId;
    }
}
