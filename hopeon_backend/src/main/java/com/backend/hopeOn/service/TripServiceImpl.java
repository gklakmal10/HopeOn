package com.backend.hopeOn.service;

import com.backend.hopeOn.domain.Trip;
import com.backend.hopeOn.entity.Attendance;
import com.backend.hopeOn.entity.Driver;
import com.backend.hopeOn.entity.Schedule;
import com.backend.hopeOn.enums.AttendanceType;
import com.backend.hopeOn.enums.TripStatus;
import com.backend.hopeOn.generic.HOResponse;
import com.backend.hopeOn.repository.AttendanceRepository;
import com.backend.hopeOn.repository.DriverRepository;
import com.backend.hopeOn.repository.ScheduleRepository;
import com.backend.hopeOn.repository.TripRepository;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class TripServiceImpl implements TripService{
    private final TripRepository tripRepository;
    private final DriverRepository driverRepository;
    private final ScheduleRepository scheduleRepository;
    private final AttendanceRepository attendanceRepository;
    @Override
    public HOResponse<Trip> save(Trip trip) {
        HOResponse<Trip> response = new HOResponse<>();

        if(trip.getTripDate() == null){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Date cannot be null");
            return response;
        }
        if(trip.getDriverId() == null){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Date cannot be null");
            return response;
        }
        if(trip.getType() == null){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Date cannot be null");
            return response;
        }

        com.backend.hopeOn.entity.Trip newTrip = new com.backend.hopeOn.entity.Trip();
        newTrip.setDate(trip.getTripDate());
        newTrip.setType(trip.getType());

        Optional<Driver> driver = driverRepository.findByIdAndActiveIsTrue(trip.getDriverId());

        if(driver.isEmpty()){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Driver not found");
            return response;
        }

        newTrip.setDriver(driver.get());
        newTrip.setStatus(TripStatus.IN_PROGRESS);
        newTrip.setPickedCount(0);

        if(tripRepository.existsByDateAndTypeAndDriver_Id(trip.getTripDate(), trip.getType(), trip.getDriverId())){
            response.setStatus(HttpStatus.OK.value());
            response.setMessage("Already created");
            return response;
        }

        com.backend.hopeOn.entity.Trip savedTrip = tripRepository.save(newTrip);

        List<Schedule> scheduleList = new ArrayList<>();

        if(trip.getType().equals(AttendanceType.TO_HOME)){
           scheduleList = scheduleRepository.findAllByDateAndToHomeIsTrueAndStudent_Vehicle_Driver_Id(trip.getTripDate(), trip.getDriverId());
        }
        if(trip.getType().equals(AttendanceType.TO_SCHOOL)){
            scheduleList = scheduleRepository.findAllByDateAndToSchoolIsTrueAndStudent_Vehicle_Driver_Id(trip.getTripDate(), trip.getDriverId());
        }

        List<Attendance> attendanceList = new ArrayList<>();

        for (Schedule schedule : scheduleList
             ) {
            Attendance attendance = new Attendance();
            attendance.setTrip(savedTrip);
            attendance.setStudent(schedule.getStudent());
            attendance.setPicked(false);

            Attendance savedAttendance = attendanceRepository.save(attendance);
            attendanceList.add(savedAttendance);
        }

        response.setStatus(HttpStatus.OK.value());
        savedTrip.setAttendanceList(attendanceList);
        response.setObject(TripEntityToDomain(savedTrip));

        return response;

    }

    @Override
    public HOResponse<Trip> findTrip(Long driverId, AttendanceType type, LocalDate date) {
        Optional<com.backend.hopeOn.entity.Trip> optionalTrip = tripRepository.findByDateAndTypeAndDriver_Id(date, type, driverId);
        HOResponse<Trip> response = new HOResponse<>();

        if(optionalTrip.isEmpty()){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Trip not found");
            return response;
        }

        response.setStatus(HttpStatus.OK.value());
        response.setObject(TripEntityToDomain(optionalTrip.get()));

        return response;
    }

    @Override
    public HOResponse<Trip> markPickUp(Long attendanceId) {
        HOResponse<Trip> response = new HOResponse<>();

        Optional<Attendance> optionalAttendance = attendanceRepository.findById(attendanceId);
        if(optionalAttendance.isEmpty()){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Attendance not found");
            return response;
        }

        Attendance attendance = optionalAttendance.get();

        if(attendance.isPicked()){
            response.setStatus(HttpStatus.OK.value());
            response.setObject(TripEntityToDomain(tripRepository.findById(attendance.getTrip().getId()).get()));

            return response;
        }else{
            attendance.setPicked(true);

            Optional<com.backend.hopeOn.entity.Trip> optionalTrip= tripRepository.findById(attendance.getTrip().getId());
            com.backend.hopeOn.entity.Trip trip = optionalTrip.get();

            trip.setPickedCount(trip.getPickedCount()+1);
            com.backend.hopeOn.entity.Trip savedTrip =  tripRepository.save(trip);

            attendanceRepository.save(attendance);

            response.setStatus(HttpStatus.OK.value());
            response.setObject(TripEntityToDomain(savedTrip));

            return response;
        }
    }

    @Override
    public HOResponse<Trip> endTrip(Long id) {
        Optional<com.backend.hopeOn.entity.Trip> optionalTrip = tripRepository.findById(id);
        HOResponse<Trip> response = new HOResponse<>();

        if(optionalTrip.isEmpty()){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Trip not found");
            return response;
        }
        com.backend.hopeOn.entity.Trip trip = optionalTrip.get();

        trip.setStatus(TripStatus.DONE);

        com.backend.hopeOn.entity.Trip savedTrip = tripRepository.save(trip);

        response.setStatus(HttpStatus.OK.value());
        response.setObject(TripEntityToDomain(savedTrip));

        return response;

    }

    private com.backend.hopeOn.domain.Attendance AttendanceEntityToDomain(Attendance attendance){

        com.backend.hopeOn.domain.Attendance attendanceDomain = new com.backend.hopeOn.domain.Attendance();
        attendanceDomain.setId(attendance.getId());
        attendanceDomain.setTripId(attendance.getTrip().getId());
        attendanceDomain.setStudentId(attendance.getStudent().getId());
        attendanceDomain.setFullName(attendance.getStudent().getFullName());
        attendanceDomain.setPicked(attendance.isPicked());

        return attendanceDomain;
    }

    private Trip TripEntityToDomain(com.backend.hopeOn.entity.Trip trip){

        Trip tripDomain = new Trip();
        tripDomain.setId(trip.getId());
        tripDomain.setTripDate(trip.getDate());
        tripDomain.setDriverId(trip.getDriver().getId());
        tripDomain.setStatus(trip.getStatus());
        tripDomain.setType(trip.getType());
        tripDomain.setPickedCount(trip.getPickedCount());

        if(trip.getAttendanceList() != null){
            tripDomain.setAttendanceList(trip.getAttendanceList().isEmpty() ? Collections.emptyList() : trip.getAttendanceList().stream().map(this::AttendanceEntityToDomain).toList());

        }

        return tripDomain;
    }
}
