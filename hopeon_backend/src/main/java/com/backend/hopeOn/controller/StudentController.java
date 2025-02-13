package com.backend.hopeOn.controller;

import com.backend.hopeOn.domain.Driver;
import com.backend.hopeOn.domain.Student;
import com.backend.hopeOn.generic.HOResponse;
import org.springframework.web.bind.annotation.*;

import java.util.List;

public interface StudentController {

    @GetMapping("/findAll")
    @ResponseBody
    HOResponse<List<Student>> findAll();

    @PostMapping
    @ResponseBody
    HOResponse<Student> save(@RequestBody Student student);
    @GetMapping("/findById")
    @ResponseBody
    HOResponse<Student> findById(@RequestParam Long id);
    @PutMapping
    @ResponseBody
    HOResponse<Student> update(@RequestBody Student student);
    @PutMapping("/assignVehicle")
    @ResponseBody
    HOResponse<Student> assignVehicle(@RequestParam Long id, @RequestParam Long vehicleId);


}
