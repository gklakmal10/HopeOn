package com.backend.hopeOn.domain;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
@Getter
@Setter
public class Alert extends AbstractModel{
    private Long driverId;
    private String message;
    private LocalDateTime sendAt;
}
