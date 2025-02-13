package com.backend.hopeOn.service;

import com.backend.hopeOn.domain.Alert;
import com.backend.hopeOn.generic.HOResponse;
import com.backend.hopeOn.repository.AlertRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AlertServiceImpl implements AlertService{
    private final AlertRepository alertRepository;
    @Override
    public HOResponse<String> save(String message, Long driverId) {
        HOResponse<String> response = new HOResponse<>();
        if(!StringUtils.hasText(message)){
           response.setStatus(HttpStatus.BAD_REQUEST.value());
           response.setMessage("Message Cant be empty");
           return response;
        }
        if(driverId == null){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Sender Cant be empty");
            return response;
        }
        com.backend.hopeOn.entity.Alert alert = new com.backend.hopeOn.entity.Alert();
        alert.setDriverId(driverId);
        alert.setMessage(message);
        alert.setSendAt(LocalDateTime.now());

        alertRepository.save(alert);

        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Alert Sent");
        return response;
    }

    @Override
    public HOResponse<List<Alert>> findAllByDriverId(Long driverId) {
        HOResponse<List<Alert>> response = new HOResponse<>();

        List<Alert> alerts = alertRepository.findAllByDriverId(driverId).stream().map(this::EntityToDomainMapper).toList();
        if(driverId == null){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Sender Cant be empty");
            return response;
        }
        response.setStatus(HttpStatus.OK.value());
        response.setObject(alerts);
        return response;
    }

    private Alert EntityToDomainMapper(com.backend.hopeOn.entity.Alert alertEntity){
        Alert alertDomain = new Alert();
        alertDomain.setId(alertEntity.getId());
        alertDomain.setDriverId(alertEntity.getDriverId());
        alertDomain.setMessage(alertEntity.getMessage());
        alertDomain.setSendAt(alertEntity.getSendAt());

        return alertDomain;
    }
}
