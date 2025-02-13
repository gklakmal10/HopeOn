package com.backend.hopeOn.service;

import com.backend.hopeOn.domain.Driver;
import com.backend.hopeOn.generic.HOResponse;
import jakarta.mail.MessagingException;

import java.util.List;

public interface DriverService {
    HOResponse<List<Driver>> findAll();
    HOResponse<List<Driver>> findAllUnAssigned();
    HOResponse<Driver> findById(Long id);
    HOResponse<List<Driver>> search(Driver driverSearch);
    HOResponse<Driver> assignVehicle( Long id, Long vehicleId);
    HOResponse<Driver> save(Driver driver) throws MessagingException;
    HOResponse<Driver> update(Driver driver);
    HOResponse<String> delete(Long id);
}
