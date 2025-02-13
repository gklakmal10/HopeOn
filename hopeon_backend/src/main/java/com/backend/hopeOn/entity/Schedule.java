package com.backend.hopeOn.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
@Getter
@Setter
@Entity(name = "schedule")
public class Schedule extends AbstractEntity{
    @Column(name = "date")
    private LocalDate date;
    @ManyToOne
    @JoinColumn(name = "student_id", referencedColumnName ="id")
    private Student student;
    @Column(name = "to_school")
    private Boolean toSchool;
    @Column(name = "to_home")
    private Boolean toHome;
}
