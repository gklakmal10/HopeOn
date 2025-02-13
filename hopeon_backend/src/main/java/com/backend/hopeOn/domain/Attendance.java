package com.backend.hopeOn.domain;

import com.backend.hopeOn.enums.AttendanceType;
import com.backend.hopeOn.enums.TripStatus;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
public class Attendance extends AbstractModel{
    private Long tripId;
    private Long studentId;
    private String fullName;
    private boolean isPicked;
}
