package com.backend.hopeOn.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity(name = "std_attendance")
public class Attendance extends AbstractEntity{
    @ManyToOne
    @JoinColumn(name = "trip_id", referencedColumnName ="id")
    private Trip trip;
    @ManyToOne
    @JoinColumn(name = "student_id", referencedColumnName ="id")
    private Student student;
    @Column(name = "is_picked", columnDefinition = "DEFAULT 0")
    private boolean isPicked = false;

}
