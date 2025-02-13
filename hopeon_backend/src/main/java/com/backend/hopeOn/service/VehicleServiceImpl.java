package com.backend.hopeOn.service;

import com.backend.hopeOn.domain.Student;
import com.backend.hopeOn.domain.Vehicle;
import com.backend.hopeOn.entity.Driver;
import com.backend.hopeOn.entity.Schedule;
import com.backend.hopeOn.enums.AttendanceType;
import com.backend.hopeOn.generic.HOException;
import com.backend.hopeOn.generic.HOResponse;
import com.backend.hopeOn.repository.VehicleRepository;
import com.backend.hopeOn.response.AttendanceResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Service
@RequiredArgsConstructor
public class VehicleServiceImpl implements VehicleService {

    private final VehicleRepository vehicleRepository;
    private final StudentServiceImpl studentService;

    @Override
    public HOResponse<List<Vehicle>> findAll() {
        List<Vehicle> vehicleList = vehicleRepository.findAll().stream().map(this::EntityToDomainMapper).toList();

        HOResponse<List<Vehicle>> response = new HOResponse<>();
        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Vehicle list fetched successfully");
        response.setObject(vehicleList);

        return response;
    }

    @Override
    public HOResponse<List<Vehicle>> findAllAssignable() {
        List<Vehicle> vehicleList = vehicleRepository.findAllByActiveIsTrue()
                .stream()
                .filter(vehicle -> (vehicle.getSeatCount() - vehicle.getAvailableSeatCount()) < vehicle.getSeatCount())
                .map(this::EntityToDomainMapper).toList();

        HOResponse<List<Vehicle>> response = new HOResponse<>();
        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Vehicle list fetched successfully");
        response.setObject(vehicleList);

        return response;
    }

    @Override
    public HOResponse<List<AttendanceResponse>> getStudentAttendance(LocalDate date, Long vehicleId, AttendanceType type) {
        com.backend.hopeOn.entity.Vehicle vehicleEntity = vehicleRepository.findByIdAndActiveIsTrue(vehicleId)
                .orElseThrow(() -> new HOException("Vehicle not found"));

        List<AttendanceResponse> attendance = new ArrayList<>();

        for (com.backend.hopeOn.entity.Student student : vehicleEntity.getStudentList()
        ) {
            AttendanceResponse attendResponse = new AttendanceResponse();
            attendResponse.setId(student.getId());
            attendResponse.setRegNo(student.getRegNo());
            attendResponse.setFullName(student.getFullName());
            attendResponse.setGrade(student.getGrade());
            attendResponse.setStudentClass(student.getStudentClass());
            attendResponse.setImageUrl(student.getImageUrl());

            List<Schedule> stSchedules = student.getSchedules().stream().filter(schedule -> schedule.getDate().equals(date)).toList();

            if (!stSchedules.isEmpty()) {
                if (Objects.equals(AttendanceType.TO_SCHOOL, type)) {
                    attendResponse.setAttendance(stSchedules.get(0).getToSchool());
                } else if (Objects.equals(AttendanceType.TO_HOME, type)) {
                    attendResponse.setAttendance(stSchedules.get(0).getToHome());
                }
            } else {
                attendResponse.setAttendance(false);
            }

            attendance.add(attendResponse);
        }

        HOResponse<List<AttendanceResponse>> response = new HOResponse<>();
        response.setStatus(HttpStatus.OK.value());
        response.setObject(attendance);

        return response;
    }

    @Override
    public HOResponse<Vehicle> findById(Long id) {
        com.backend.hopeOn.entity.Vehicle vehicleEntity = vehicleRepository.findByIdAndActiveIsTrue(id)
                .orElseThrow(() -> new HOException("Vehicle not found"));

        HOResponse<Vehicle> response = new HOResponse<>();
        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Vehicle fetched successfully");
        response.setObject(EntityToDomainMapper(vehicleEntity));

        return response;
    }

    @Override
    public HOResponse<Vehicle> findByDriver(Long driverId) {
        com.backend.hopeOn.entity.Vehicle vehicleEntity = vehicleRepository.findByDriver_IdAndActiveIsTrue(driverId)
                .orElseThrow(() -> new HOException("Vehicle not found"));

        HOResponse<Vehicle> response = new HOResponse<>();
        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Vehicle fetched successfully");
        response.setObject(EntityToDomainMapper(vehicleEntity));

        return response;
    }

    @Override
    public HOResponse<Vehicle> save(Vehicle vehicle) {
        com.backend.hopeOn.entity.Vehicle newVehicle = vehicleRepository.save(DomainToEntityMapper(vehicle));

        HOResponse<Vehicle> response = new HOResponse<>();
        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Vehicle saved successfully");
        response.setObject(EntityToDomainMapper(newVehicle));

        return response;
    }

    @Override
    public HOResponse<Vehicle> update(Vehicle vehicle) {
        com.backend.hopeOn.entity.Vehicle existingVehicle = vehicleRepository.findById(vehicle.getId())
                .orElseThrow(() -> new HOException("Vehicle not found"));

        existingVehicle.setVehicleNo(vehicle.getVehicleNo());
        existingVehicle.setType(vehicle.getType());
        existingVehicle.setColor(vehicle.getColor());
        existingVehicle.setBrand(vehicle.getBrand());
        existingVehicle.setModel(vehicle.getModel());
        existingVehicle.setAvailableSeatCount(existingVehicle.getAvailableSeatCount() + (vehicle.getSeatCount() - existingVehicle.getSeatCount()));
        existingVehicle.setSeatCount(vehicle.getSeatCount());
        existingVehicle.setRoute(vehicle.getRoute());
        existingVehicle.setLocations(vehicle.getLocations());
        existingVehicle.setActive(vehicle.getActive());

        existingVehicle.setStartLat(vehicle.getStartLat());
        existingVehicle.setStartLong(vehicle.getStartLong());
        existingVehicle.setEndLat(vehicle.getEndLat());
        existingVehicle.setEndLong(vehicle.getEndLong());

        com.backend.hopeOn.entity.Vehicle updatedVehicle = vehicleRepository.save(existingVehicle);

        HOResponse<Vehicle> response = new HOResponse<>();
        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Vehicle updated successfully");
        response.setObject(EntityToDomainMapper(updatedVehicle));

        return response;
    }

    @Override
    public HOResponse<String> delete(Long id) {
        com.backend.hopeOn.entity.Vehicle vehicleEntity = vehicleRepository.findById(id)
                .orElseThrow(() -> new HOException("Vehicle not found"));

        vehicleEntity.setActive(false);
        vehicleRepository.save(vehicleEntity);

        HOResponse<String> response = new HOResponse<>();
        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Vehicle deleted successfully");
        response.setObject("Vehicle ID " + id + " deleted");

        return response;
    }

    private Vehicle EntityToDomainMapper(com.backend.hopeOn.entity.Vehicle vehicleEntity) {
        if (vehicleEntity == null) {
            return null;
        }

        Vehicle vehicleDomain = new Vehicle();
        vehicleDomain.setId(vehicleEntity.getId());
        vehicleDomain.setVehicleNo(vehicleEntity.getVehicleNo());
        vehicleDomain.setType(vehicleEntity.getType());
        vehicleDomain.setColor(vehicleEntity.getColor());
        vehicleDomain.setBrand(vehicleEntity.getBrand());
        vehicleDomain.setModel(vehicleEntity.getModel());
        vehicleDomain.setSeatCount(vehicleEntity.getSeatCount());
        vehicleDomain.setAvailableSeatCount(vehicleEntity.getAvailableSeatCount());
        vehicleDomain.setRoute(vehicleEntity.getRoute());
        vehicleDomain.setImageUrl(vehicleEntity.getImageUrl());
        vehicleDomain.setLocations(vehicleEntity.getLocations());
        vehicleDomain.setActive(vehicleEntity.getActive());

        vehicleDomain.setStartLat(vehicleEntity.getStartLat());
        vehicleDomain.setStartLong(vehicleEntity.getStartLong());
        vehicleDomain.setEndLat(vehicleEntity.getEndLat());
        vehicleDomain.setEndLong(vehicleEntity.getEndLong());

        if (vehicleEntity.getDriver() != null) {
            vehicleDomain.setDriverId(vehicleEntity.getDriver().getId());
            vehicleDomain.setDriverName(vehicleEntity.getDriver().getFullName());
            vehicleDomain.setDriverContactNo(vehicleEntity.getDriver().getContactNo());
            vehicleDomain.setDriverNIC(vehicleEntity.getDriver().getNicNo());
        }

        if (!vehicleEntity.getStudentList().isEmpty()) {
            List<Student> studentList = new ArrayList<>();
            vehicleEntity.getStudentList().forEach(student -> studentList.add(studentService.StudentEntityToDomainMapper(student)));

            vehicleDomain.setStudentList(studentList);
        }

        return vehicleDomain;
    }

    private com.backend.hopeOn.entity.Vehicle DomainToEntityMapper(Vehicle vehicleDomain) {
        if (vehicleDomain == null) {
            return null;
        }

        com.backend.hopeOn.entity.Vehicle vehicleEntity = new com.backend.hopeOn.entity.Vehicle();

        if (vehicleDomain.getId() != null) {
            vehicleEntity.setId(vehicleDomain.getId());
        }
        vehicleEntity.setVehicleNo(vehicleDomain.getVehicleNo());
        vehicleEntity.setType(vehicleDomain.getType());
        vehicleEntity.setColor(vehicleDomain.getColor());
        vehicleEntity.setBrand(vehicleDomain.getBrand());
        vehicleEntity.setModel(vehicleDomain.getModel());
        vehicleEntity.setSeatCount(vehicleDomain.getSeatCount());
        vehicleEntity.setAvailableSeatCount(vehicleDomain.getAvailableSeatCount());
        vehicleEntity.setRoute(vehicleDomain.getRoute());
        vehicleEntity.setImageUrl(vehicleDomain.getImageUrl());
        vehicleEntity.setLocations(vehicleDomain.getLocations());
        vehicleEntity.setActive(vehicleDomain.getActive());

        vehicleEntity.setStartLat(vehicleDomain.getStartLat());
        vehicleEntity.setStartLong(vehicleDomain.getStartLong());
        vehicleEntity.setEndLat(vehicleDomain.getEndLat());
        vehicleEntity.setEndLong(vehicleDomain.getEndLong());

        if (vehicleDomain.getDriverId() != null) {
            Driver driver = new Driver();
            driver.setId(vehicleDomain.getDriverId());
            vehicleEntity.setDriver(driver);
        }

        return vehicleEntity;
    }
}
