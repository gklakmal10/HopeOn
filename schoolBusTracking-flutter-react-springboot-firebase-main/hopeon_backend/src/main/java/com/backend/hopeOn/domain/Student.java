package com.backend.hopeOn.domain;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class Student extends User{
    private String regNo;
    private String fullName;
    private String grade;
    private String studentClass;
    private String parentName;
    private String contactNo;
    private String gender;
    private Integer age;
    private String location;
    private String imageUrl;
    private Boolean active;
    private Long vehicleId;
    private String vehicleNo;
    private String vehicleDetails;
    private Long driverId;
    private String driverName;
    private String driverContactNo;
    private String driverNIC;
    private List<Schedule> schedules;
}
