package com.backend.hopeOn.controller;

import com.backend.hopeOn.domain.Vehicle;
import com.backend.hopeOn.enums.AttendanceType;
import com.backend.hopeOn.generic.HOException;
import com.backend.hopeOn.generic.HOResponse;
import com.backend.hopeOn.response.AttendanceResponse;
import com.backend.hopeOn.service.VehicleService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/vehicle")
@RequiredArgsConstructor
public class VehicleControllerImpl implements VehicleController {

    private final VehicleService vehicleService;

    @Override
    public HOResponse<List<Vehicle>> findAll() {
        try {
            return vehicleService.findAll();
        } catch (Exception e) {
            throw new HOException("Error while fetching vehicle list: " + e.getMessage());
        }
    }

    @Override
    public HOResponse<List<Vehicle>> findAllAssignable() {
        try {
            return vehicleService.findAllAssignable();
        } catch (Exception e) {
            throw new HOException("Error while fetching vehicle list: " + e.getMessage());
        }
    }

    @Override
    public HOResponse<List<AttendanceResponse>> getStudentAttendance(LocalDate date, Long vehicleId, AttendanceType type) {
        try {
            return vehicleService.getStudentAttendance(date, vehicleId, type);
        } catch (Exception e) {
            throw new HOException("Error while fetching vehicle list: " + e.getMessage());
        }
    }

    @Override
    public HOResponse<Vehicle> findById(Long id) {
        try {
            return vehicleService.findById(id);
        } catch (Exception e) {
            throw new HOException("Error while fetching vehicle by ID: " + e.getMessage());
        }
    }

    @Override
    public HOResponse<Vehicle> findByDriver(Long driverId) {
        try {
            return vehicleService.findByDriver(driverId);
        } catch (Exception e) {
            throw new HOException("Error while fetching vehicle by ID: " + e.getMessage());
        }
    }

    @Override
    public HOResponse<Vehicle> save(Vehicle vehicle) {
        try {
            return vehicleService.save(vehicle);
        } catch (Exception e) {
            throw new HOException("Error while saving vehicle: " + e.getMessage());
        }
    }

    @Override
    public HOResponse<Vehicle> update(Vehicle vehicle) {
        try {
            return vehicleService.update(vehicle);
        } catch (Exception e) {
            throw new HOException("Error while updating vehicle: " + e.getMessage());
        }
    }

    @Override
    public HOResponse<String> delete(Long id) {
        try {
            return vehicleService.delete(id);
        } catch (Exception e) {
            throw new HOException("Error while deleting vehicle: " + e.getMessage());
        }
    }
}
