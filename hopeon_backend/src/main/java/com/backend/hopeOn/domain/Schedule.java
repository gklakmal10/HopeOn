package com.backend.hopeOn.domain;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
@Getter
@Setter
public class Schedule extends AbstractModel {
    private LocalDate date;
    private Long studentId;
    private Boolean toSchool;
    private Boolean toHome;
}
