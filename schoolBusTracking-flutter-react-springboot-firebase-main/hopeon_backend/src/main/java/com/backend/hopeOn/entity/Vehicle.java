package com.backend.hopeOn.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@Entity(name = "vehicle")
public class Vehicle extends AbstractEntity{
    @Column(name = "vehicle_no")
    private String vehicleNo;
    @Column(name = "type")
    private String type;
    @Column(name = "color")
    private String color;
    @Column(name = "brand")
    private String brand;
    @Column(name = "model")
    private String model;
    @Column(name = "seat_count")
    private Integer seatCount;
    @Column(name = "available_seat_count")
    private Integer availableSeatCount;
    @Column(name = "route")
    private String route;
    @Column(name = "image_url")
    private String imageUrl;
    @Column(name = "locations")
    private String locations;

    @Column(name = "start_lat")
    private String startLat;
    @Column(name = "start_long")
    private String startLong;

    @Column(name = "end_lat")
    private String endLat;
    @Column(name = "end_long")
    private String endLong;

    @Column(name = "active")
    private Boolean active;
    @OneToOne(mappedBy = "vehicle")
    private Driver driver;
    @OneToMany(mappedBy = "vehicle")
    private List<Student> studentList;
}
