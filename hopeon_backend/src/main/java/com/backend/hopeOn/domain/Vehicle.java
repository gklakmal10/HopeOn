package com.backend.hopeOn.domain;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class Vehicle extends AbstractModel{
    private String vehicleNo;
    private String type;
    private String color;
    private String brand;
    private String model;
    private Integer seatCount;
    private Integer availableSeatCount;
    private String route;
    private String imageUrl;
    private String locations;
    private Boolean active;
    private Long driverId;
    private String driverName;
    private String driverContactNo;
    private String driverNIC;
    private String startLat;
    private String startLong;
    private String endLat;
    private String endLong;
    private List<Student> studentList;
}
