package com.backend.hopeOn.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity(name = "driver")
public class Driver extends User{
    @Column(name = "nic_no")
    private String nicNo;
    @Column(name = "license_no")
    private String licenseNo;
    @Column(name = "contact_no")
    private String contactNo;
    @Column(name = "gender")
    private String gender;
    @Column(name = "age")
    private String age;
    @Column(name = "experience")
    private String experience;
    @Column(name = "location")
    private String location;
    @Column(name = "image_url")
    private String imageUrl;
    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "vehicle_id", referencedColumnName = "id")
    private Vehicle vehicle;
}
