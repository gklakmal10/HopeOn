package com.backend.hopeOn.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity(name = "alert")
public class Alert extends AbstractEntity{
    @Column(name = "driver_id")
    private Long driverId;
    @Column(name = "message")
    private String message;
    @Column(name = "sendAt")
    private LocalDateTime sendAt;

}
