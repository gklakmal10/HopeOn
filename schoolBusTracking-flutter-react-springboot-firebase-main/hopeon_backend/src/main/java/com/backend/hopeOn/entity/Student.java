package com.backend.hopeOn.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NonNull;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@Entity(name = "student")
public class Student extends User{

    @Column(name = "reg_no")
    private String regNo;
    @Column(name = "grade")
    private String grade;
    @Column(name = "student_class")
    private String studentClass;
    @Column(name = "parent_name")
    private String parentName;
    @Column(name = "contact_no")
    private String contactNo;
    @Column(name = "gender")
    private String gender;
    @Column(name = "age")
    private Integer age;
    @Column(name = "location")
    private String location;
    @Column(name = "image_url")
    private String imageUrl;
    @ManyToOne
    @JoinColumn(name = "vehicle_id", referencedColumnName ="id")
    private Vehicle vehicle;
    @OneToMany(mappedBy = "student")
    private List<Schedule> schedules;
}
