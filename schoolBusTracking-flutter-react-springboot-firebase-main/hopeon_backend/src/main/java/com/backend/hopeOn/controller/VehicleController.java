package com.backend.hopeOn.controller;

import com.backend.hopeOn.domain.Vehicle;
import com.backend.hopeOn.enums.AttendanceType;
import com.backend.hopeOn.generic.HOResponse;
import com.backend.hopeOn.response.AttendanceResponse;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

public interface VehicleController {

    @GetMapping("/findAll")
    @ResponseBody
    HOResponse<List<Vehicle>> findAll();

    @GetMapping("/findAllAssignable")
    @ResponseBody
    HOResponse<List<Vehicle>> findAllAssignable();
    @GetMapping("/getStudentAttendance")
    @ResponseBody
    HOResponse<List<AttendanceResponse>> getStudentAttendance(@RequestParam LocalDate date, @RequestParam Long vehicleId, @RequestParam AttendanceType type);
    @GetMapping("/{id}")
    @ResponseBody
    HOResponse<Vehicle> findById(@PathVariable Long id);
    @GetMapping("/getByDriver")
    @ResponseBody
    HOResponse<Vehicle> findByDriver(@RequestParam Long driverId);
    @PostMapping()
    @ResponseBody
    HOResponse<Vehicle> save(@RequestBody Vehicle vehicle);

    @PutMapping()
    @ResponseBody
    HOResponse<Vehicle> update(@RequestBody Vehicle vehicle);

    @DeleteMapping("/{id}")
    @ResponseBody
    HOResponse<String> delete(@PathVariable Long id);
}
