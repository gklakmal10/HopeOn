package com.backend.hopeOn.controller;

import com.backend.hopeOn.domain.Alert;
import com.backend.hopeOn.generic.HOResponse;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

public interface AlertController {
    @PostMapping()
    @ResponseBody
    HOResponse<String> save(@RequestParam String message, @RequestParam Long driverId);
    @GetMapping
    @ResponseBody
    HOResponse<List<Alert>> findAllByDriverId(@RequestParam Long driverId);
}
