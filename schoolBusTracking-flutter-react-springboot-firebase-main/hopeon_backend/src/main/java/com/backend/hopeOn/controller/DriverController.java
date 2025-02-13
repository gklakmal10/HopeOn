package com.backend.hopeOn.controller;

import com.backend.hopeOn.domain.Driver;
import com.backend.hopeOn.generic.HOResponse;
import org.springframework.web.bind.annotation.*;

import java.util.List;

public interface DriverController {

    @GetMapping("/findAll")
    @ResponseBody
    HOResponse<List<Driver>> findAll();

    @GetMapping("/findAllUnAssigned")
    @ResponseBody
    HOResponse<List<Driver>> findAllUnAssigned();

    @GetMapping("/findById")
    @ResponseBody
    HOResponse<Driver> findById(@RequestParam Long id);

    @PostMapping()
    @ResponseBody
    HOResponse<Driver> save(@RequestBody Driver driver);

    @PutMapping("/assignVehicle")
    @ResponseBody
    HOResponse<Driver> assignVehicle(@RequestParam Long id, @RequestParam Long vehicleId);

    @PutMapping()
    @ResponseBody
    HOResponse<Driver> update(@RequestBody Driver driver);

    @DeleteMapping("/{id}")
    @ResponseBody
    HOResponse<String> delete(@PathVariable Long id);
}
