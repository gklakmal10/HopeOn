package com.backend.hopeOn.service;

import com.backend.hopeOn.domain.Vehicle;
import com.backend.hopeOn.enums.AttendanceType;
import com.backend.hopeOn.generic.HOResponse;
import com.backend.hopeOn.response.AttendanceResponse;

import java.time.LocalDate;
import java.util.List;

public interface VehicleService {
    HOResponse<List<Vehicle>> findAll();
    HOResponse<List<Vehicle>> findAllAssignable();
    HOResponse<List<AttendanceResponse>> getStudentAttendance(LocalDate date, Long vehicleId, AttendanceType type);
    HOResponse<Vehicle> findById(Long id);
    HOResponse<Vehicle> findByDriver(Long driverId);
    HOResponse<Vehicle> save(Vehicle vehicle);
    HOResponse<Vehicle> update(Vehicle vehicle);
    HOResponse<String> delete(Long id);
}
