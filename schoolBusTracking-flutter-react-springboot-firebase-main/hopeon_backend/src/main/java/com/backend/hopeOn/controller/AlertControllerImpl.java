package com.backend.hopeOn.controller;

import com.backend.hopeOn.domain.Alert;
import com.backend.hopeOn.generic.HOResponse;
import com.backend.hopeOn.service.AlertService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/alert")
@RequiredArgsConstructor
public class AlertControllerImpl implements AlertController{
    private final AlertService alertService;
    @Override
    public HOResponse<String> save(String message, Long driverId) {
        try {
            return alertService.save(message, driverId);
        }catch (Exception e) {
            HOResponse<String> response = new HOResponse<>();
            response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
            response.setMessage(e.getMessage());
            return response;
        }
    }

    @Override
    public HOResponse<List<Alert>> findAllByDriverId(Long driverId) {
        try {
            return alertService.findAllByDriverId(driverId);
        }catch (Exception e) {
            HOResponse<List<Alert>> response = new HOResponse<>();
            response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
            response.setMessage(e.getMessage());
            return response;
        }
    }
}
