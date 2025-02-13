package com.backend.hopeOn.service;

import com.backend.hopeOn.domain.Driver;
import com.backend.hopeOn.entity.Vehicle;
import com.backend.hopeOn.enums.UserType;
import com.backend.hopeOn.generic.HOException;
import com.backend.hopeOn.generic.HOResponse;
import com.backend.hopeOn.repository.DriverRepository;
import com.backend.hopeOn.repository.UserRepository;
import com.backend.hopeOn.repository.VehicleRepository;
import com.backend.hopeOn.util.PasswordHashingUtil;
import jakarta.mail.MessagingException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class DriverServiceImpl implements DriverService {
    private final UserRepository userRepository;
    private final DriverRepository driverRepository;
    private final VehicleRepository vehicleRepository;
    private final EmailService emailService;

    @Override
    public HOResponse<List<Driver>> findAll() {
        List<Driver> driverList = driverRepository.findAll().stream().map(this::entityToDomainMapper).toList();

        HOResponse<List<Driver>> response = new HOResponse<>();
        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Driver list fetched successfully.");
        response.setObject(driverList);

        return response;
    }

    @Override
    public HOResponse<List<Driver>> findAllUnAssigned() {
        List<Driver> driverList = driverRepository.findAllByActiveIsTrue().stream().filter(driver -> driver.getVehicle() == null).map(this::entityToDomainMapper).toList();

        HOResponse<List<Driver>> response = new HOResponse<>();
        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Driver list fetched successfully.");
        response.setObject(driverList);

        return response;
    }

    @Override
    public HOResponse<Driver> findById(Long id) {
        return driverRepository.findByIdAndActiveIsTrue(id).map(driver -> {
            HOResponse<Driver> response = new HOResponse<>();
            response.setStatus(HttpStatus.OK.value());
            response.setMessage("Driver fetched successfully.");
            response.setObject(entityToDomainMapper(driver));
            return response;
        }).orElseThrow(() -> new HOException("Driver not found with id: " + id));
    }

    @Override
    public HOResponse<List<Driver>> search(Driver driverSearch) {
        // Implement search logic if required
        return null;
    }

    @Override
    public HOResponse<Driver> assignVehicle(Long id, Long vehicleId) {
        HOResponse<Driver> response = new HOResponse<>();
        Optional<com.backend.hopeOn.entity.Driver> optionalDriver = driverRepository.findByIdAndActiveIsTrue(id);
        if(optionalDriver.isEmpty()){
            throw new HOException("Driver not found", HttpStatus.BAD_REQUEST);
        }
        Optional<Vehicle> optionalVehicle = vehicleRepository.findByIdAndActiveIsTrue(vehicleId);
        if(optionalVehicle.isEmpty()){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Vehicle not found");
            return response;
        }

        com.backend.hopeOn.entity.Driver existingDriver = optionalDriver.get();
        Vehicle vehicle = optionalVehicle.get();

        existingDriver.setVehicle(vehicle);

        com.backend.hopeOn.entity.Driver updatedDriver =  driverRepository.save(existingDriver);


        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Vehicle assigned successfully");
        response.setObject(entityToDomainMapper(updatedDriver));

        return response;
    }

    @Override
    public HOResponse<Driver> save(Driver driver) throws MessagingException {
        HOResponse<Driver> response = new HOResponse<>();

        if(validateDriver(driver) != null) {
            return validateDriver(driver);
        }

        Optional<com.backend.hopeOn.entity.Driver> optionalDriver =  driverRepository.findByNicNoAndActiveIsTrue(driver.getNicNo());
        if (optionalDriver.isPresent()) {
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Driver already has an account");
            return response;
        }

        com.backend.hopeOn.entity.Driver newDriver = userRepository.save(domainToEntityMapper(driver));
        emailService.sendCredentials(driver.getEmail(), driver.getPassword());

        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Driver saved successfully.");
        response.setObject(entityToDomainMapper(newDriver));

        return response;
    }

    @Override
    public HOResponse<Driver> update(Driver driver) {
        // Find existing driver entity from the database
        Optional<com.backend.hopeOn.entity.Driver> optionalDriver = driverRepository.findById(driver.getId());

        if (optionalDriver.isEmpty()) {
            throw new HOException("Driver not found", HttpStatus.BAD_REQUEST);
        }

        // Get the existing driver entity
        com.backend.hopeOn.entity.Driver existingDriver = optionalDriver.get();

        // Update user fields (inherited from User class)
        existingDriver.setFullName(driver.getFullName());
        existingDriver.setNicNo(driver.getNicNo());
        existingDriver.setLicenseNo(driver.getLicenseNo());
        existingDriver.setContactNo(driver.getContactNo());
        existingDriver.setGender(driver.getGender());
        existingDriver.setAge(driver.getAge());
        existingDriver.setLocation(driver.getLocation());
        existingDriver.setImageUrl(driver.getImageUrl());
        existingDriver.setActive(driver.getActive());

        // Update password only if a new one is provided
        if (StringUtils.hasText(driver.getPassword())) {
            PasswordHashingUtil passwordHashingUtil = new PasswordHashingUtil();
            existingDriver.setPassword(passwordHashingUtil.hashPassword(driver.getPassword()));
        }

        // Update driver-specific fields
        existingDriver.setExperience(driver.getExperience());

        // Handle vehicle assignment (only if provided)
        if (driver.getVehicleId() != null && (existingDriver.getVehicle() == null || !existingDriver.getVehicle().getId().equals(driver.getVehicleId()))) {
            Optional<Vehicle> optionalVehicle = vehicleRepository.findById(driver.getVehicleId());
            if (optionalVehicle.isPresent()) {
                existingDriver.setVehicle(optionalVehicle.get());
            } else {
                throw new HOException("Vehicle not found with ID: " + driver.getVehicleId(), HttpStatus.BAD_REQUEST);
            }
        }

        // Save the updated driver entity (this will also update the inherited User fields)
        com.backend.hopeOn.entity.Driver updatedDriver = driverRepository.save(existingDriver);

        // Prepare response
        HOResponse<Driver> response = new HOResponse<>();
        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Driver updated successfully.");
        response.setObject(entityToDomainMapper(updatedDriver));

        return response;
    }


    @Override
    public HOResponse<String> delete(Long id) {
        driverRepository.deleteById(id);
        HOResponse<String> response = new HOResponse<>();
        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Driver deleted successfully.");
        response.setObject("Driver with id " + id + " deleted.");
        return response;
    }

    private HOResponse<Driver> validateDriver(Driver driver) {
        HOResponse<Driver> response = new HOResponse<>();

        if (!StringUtils.hasText(driver.getNicNo())) {
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Driver NIC cannot be empty");
            return response;
        }
        if (!StringUtils.hasText(driver.getLicenseNo())) {
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Driver license number cannot be empty");
            return response;
        }
        if (!StringUtils.hasText(driver.getContactNo())) {
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Driver contact number cannot be empty");
            return response;
        }
        return null;
    }

    private Driver entityToDomainMapper(com.backend.hopeOn.entity.Driver driverEntity) {
        if (driverEntity == null) return null;

        Driver driverDomain = new Driver();
        driverDomain.setId(driverEntity.getId());
        driverDomain.setEmail(driverEntity.getEmail());
        driverDomain.setType(driverEntity.getType());
        driverDomain.setFullName(driverEntity.getFullName());
        driverDomain.setNicNo(driverEntity.getNicNo());
        driverDomain.setLicenseNo(driverEntity.getLicenseNo());
        driverDomain.setContactNo(driverEntity.getContactNo());
        driverDomain.setGender(driverEntity.getGender());
        driverDomain.setAge(driverEntity.getAge());
        driverDomain.setExperience(driverEntity.getExperience());
        driverDomain.setLocation(driverEntity.getLocation());
        driverDomain.setImageUrl(driverEntity.getImageUrl());
        driverDomain.setActive(driverEntity.getActive());
        if (driverEntity.getVehicle() != null) {
            driverDomain.setVehicleId(driverEntity.getVehicle().getId());
            driverDomain.setVehicleNo(driverEntity.getVehicle().getVehicleNo());
            driverDomain.setVehicleDetails(driverEntity.getVehicle().getType()+", "+driverEntity.getVehicle().getBrand()+", "+driverEntity.getVehicle().getModel());
            driverDomain.setVehicleRoute(driverEntity.getVehicle().getRoute());
        }
        return driverDomain;
    }

    private com.backend.hopeOn.entity.Driver domainToEntityMapper(Driver driverDomain) {
        if (driverDomain == null) return null;

        PasswordHashingUtil passwordHashingUtil = new PasswordHashingUtil();

        com.backend.hopeOn.entity.Driver driverEntity = new com.backend.hopeOn.entity.Driver();
        driverEntity.setEmail(driverDomain.getEmail());
        if(driverDomain.getId() == null){
            driverEntity.setPassword(passwordHashingUtil.hashPassword(driverDomain.getPassword()));
        }
        driverEntity.setType(UserType.DRIVER);
        driverEntity.setFullName(driverDomain.getFullName());
        driverEntity.setNicNo(driverDomain.getNicNo());
        driverEntity.setLicenseNo(driverDomain.getLicenseNo());
        driverEntity.setContactNo(driverDomain.getContactNo());
        driverEntity.setGender(driverDomain.getGender());
        driverEntity.setAge(driverDomain.getAge());
        driverEntity.setExperience(driverDomain.getExperience());
        driverEntity.setLocation(driverDomain.getLocation());
        driverEntity.setImageUrl(driverDomain.getImageUrl());
        driverEntity.setActive(driverDomain.getActive() != null ? driverDomain.getActive() : false);

        return driverEntity;
    }
}
