package com.backend.hopeOn.controller;

import com.backend.hopeOn.domain.Trip;
import com.backend.hopeOn.enums.AttendanceType;
import com.backend.hopeOn.generic.HOResponse;
import com.backend.hopeOn.service.TripService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
@RestController
@RequestMapping("/trip")
@RequiredArgsConstructor
public class TripControllerImpl implements TripController{
    private final TripService tripService;
    @Override
    public HOResponse<Trip> save(Trip trip) {
        try {
            return tripService.save(trip);
        }catch (Exception e) {
            HOResponse<Trip> response = new HOResponse<>();
            response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
            response.setMessage(e.getMessage());
            return response;
        }
    }

    @Override
    public HOResponse<Trip> findTrip(Long driverId, AttendanceType type, LocalDate date) {
        try {
            return tripService.findTrip(driverId, type, date);
        }catch (Exception e) {
            HOResponse<Trip> response = new HOResponse<>();
            response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
            response.setMessage(e.getMessage());
            return response;
        }
    }

    @Override
    public HOResponse<Trip> markPickUp(Long attendanceId) {
        try {
            return tripService.markPickUp(attendanceId);
        }catch (Exception e) {
            HOResponse<Trip> response = new HOResponse<>();
            response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
            response.setMessage(e.getMessage());
            return response;
        }
    }

    @Override
    public HOResponse<Trip> endTrip(Long id) {
        try {
            return tripService.endTrip(id);
        }catch (Exception e) {
            HOResponse<Trip> response = new HOResponse<>();
            response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
            response.setMessage(e.getMessage());
            return response;
        }
    }
}
