package com.backend.hopeOn.domain;

import com.backend.hopeOn.entity.Vehicle;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Driver extends User{
    private String nicNo;
    private String licenseNo;
    private String contactNo;
    private String gender;
    private String age;
    private String experience;
    private String location;
    private String imageUrl;
    private Boolean active;
    private Long vehicleId;
    private String vehicleNo;
    private String vehicleDetails;
    private String vehicleRoute;
}
