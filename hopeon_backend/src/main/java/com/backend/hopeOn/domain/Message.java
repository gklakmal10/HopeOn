package com.backend.hopeOn.domain;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
@Getter
@Setter
public class Message extends AbstractModel{
    private Long id;
    private String content;
    private LocalDateTime timestamp;
    private Long senderId;
    private Long receiverId;
    private String senderName;
    private String receiverName;
    private String senderImageUrl;
    private boolean isGlobalMessage;
    private boolean read;
}
