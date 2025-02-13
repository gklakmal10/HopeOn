package com.backend.hopeOn.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity(name = "grade_classes")
public class GradeClass extends AbstractEntity{
    @Column(name = "grade")
    private String grade;
    @Column(name = "classes")
    private String classes;
}
