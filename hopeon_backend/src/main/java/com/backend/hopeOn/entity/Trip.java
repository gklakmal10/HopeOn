package com.backend.hopeOn.entity;

import com.backend.hopeOn.enums.AttendanceType;
import com.backend.hopeOn.enums.TripStatus;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@Entity(name = "trip")
public class Trip extends AbstractEntity{
    @Column(name = "date")
    private LocalDate date;
    @ManyToOne
    @JoinColumn(name = "driver_id", referencedColumnName ="id")
    private Driver driver;
    @Enumerated(EnumType.STRING)
    private TripStatus status;
    @Enumerated(EnumType.STRING)
    private AttendanceType type;
    @Column(name = "picked_count")
    private Integer pickedCount;
    @OneToMany(mappedBy = "trip")
    private List<Attendance> attendanceList;
}
