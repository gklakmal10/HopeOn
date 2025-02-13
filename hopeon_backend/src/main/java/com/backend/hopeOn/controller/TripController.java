package com.backend.hopeOn.controller;

import com.backend.hopeOn.domain.Trip;
import com.backend.hopeOn.enums.AttendanceType;
import com.backend.hopeOn.generic.HOResponse;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

public interface TripController {
    @PostMapping
    @ResponseBody
    HOResponse<Trip> save(@RequestBody Trip trip);
    @GetMapping
    @ResponseBody
    HOResponse<Trip> findTrip(@RequestParam Long driverId, @RequestParam AttendanceType type, @RequestParam LocalDate date);
    @PutMapping
    @ResponseBody
    HOResponse<Trip> markPickUp(@RequestParam Long attendanceId);
    @PutMapping("/endTrip")
    @ResponseBody
    HOResponse<Trip> endTrip(@RequestParam Long id);
}
