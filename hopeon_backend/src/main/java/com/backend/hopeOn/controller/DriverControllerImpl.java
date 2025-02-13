package com.backend.hopeOn.controller;

import com.backend.hopeOn.domain.Driver;
import com.backend.hopeOn.generic.HOException;
import com.backend.hopeOn.generic.HOResponse;
import com.backend.hopeOn.service.DriverService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/driver")
@RequiredArgsConstructor
public class DriverControllerImpl implements DriverController {

    private final DriverService driverService;

    @Override
    public HOResponse<List<Driver>> findAll() {
        try {
            return driverService.findAll();
        } catch (Exception e) {
            throw new HOException("Error while fetching driver list: " + e.getMessage());
        }
    }

    @Override
    public HOResponse<List<Driver>> findAllUnAssigned() {
        try {
            return driverService.findAllUnAssigned();
        } catch (Exception e) {
            throw new HOException("Error while fetching driver list: " + e.getMessage());
        }
    }

    @Override
    public HOResponse<Driver> findById(Long id) {
        try {
            return driverService.findById(id);
        } catch (Exception e) {
            throw new HOException("Error while fetching driver by ID: " + e.getMessage());
        }
    }

    @Override
    public HOResponse<Driver> save(Driver driver) {
        try {
            return driverService.save(driver);
        } catch (Exception e) {
            throw new HOException("Error while saving driver: " + e.getMessage());
        }
    }

    @Override
    public HOResponse<Driver> assignVehicle(Long id, Long vehicleId) {
        try {
            return driverService.assignVehicle(id, vehicleId);
        } catch (Exception e) {
            throw new HOException("Error while saving driver: " + e.getMessage());
        }
    }

    @Override
    public HOResponse<Driver> update(Driver driver) {
        try {
            return driverService.update(driver);
        } catch (Exception e) {
            throw new HOException("Error while updating driver: " + e.getMessage());
        }
    }

    @Override
    public HOResponse<String> delete(Long id) {
        try {
            return driverService.delete(id);
        } catch (Exception e) {
            throw new HOException("Error while deleting driver: " + e.getMessage());
        }
    }
}
