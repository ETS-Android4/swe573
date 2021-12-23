package io.github.sgbasaraner.funxchange.model;

import java.time.LocalDateTime;

public class MessageDTO {
    final String senderId;
    final String receiverId;
    final String conversationId;
    final String senderUserName;
    final String receiverUserName;
    final String text;
    final LocalDateTime created;

    public MessageDTO(String senderId, String receiverId, String conversationId, String senderUserName, String receiverUserName, String text, LocalDateTime created) {
        this.senderId = senderId;
        this.receiverId = receiverId;
        this.conversationId = conversationId;
        this.senderUserName = senderUserName;
        this.receiverUserName = receiverUserName;
        this.text = text;
        this.created = created;
    }

    public String getSenderId() {
        return senderId;
    }

    public String getReceiverId() {
        return receiverId;
    }

    public String getConversationId() {
        return conversationId;
    }

    public String getSenderUserName() {
        return senderUserName;
    }

    public String getReceiverUserName() {
        return receiverUserName;
    }

    public String getText() {
        return text;
    }

    public LocalDateTime getCreated() {
        return created;
    }
}
