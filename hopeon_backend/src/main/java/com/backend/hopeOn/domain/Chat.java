package com.backend.hopeOn.domain;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class Chat extends AbstractModel{
    private Long driverId;
    private Long studentId;
    private String lastMessage;
    private LocalDateTime lastMessageTime;
    private int unreadCount;
}
