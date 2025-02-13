package com.backend.hopeOn.domain;

import com.backend.hopeOn.enums.AttendanceType;
import com.backend.hopeOn.enums.TripStatus;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
public class Trip extends AbstractModel{
    private LocalDate tripDate;
    private TripStatus status;
    private Long driverId;
    private AttendanceType type;
    private Integer pickedCount;
    private List<Attendance> attendanceList;
}
