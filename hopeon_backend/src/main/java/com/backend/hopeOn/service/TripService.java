package com.backend.hopeOn.service;

import com.backend.hopeOn.domain.Trip;
import com.backend.hopeOn.entity.Attendance;
import com.backend.hopeOn.enums.AttendanceType;
import com.backend.hopeOn.generic.HOResponse;

import java.time.LocalDate;

public interface TripService {
    HOResponse<Trip> save(Trip trip);
    HOResponse<Trip> findTrip(Long driverId, AttendanceType type, LocalDate date);
    HOResponse<Trip> markPickUp(Long attendanceId);
    HOResponse<Trip> endTrip(Long id);
}
