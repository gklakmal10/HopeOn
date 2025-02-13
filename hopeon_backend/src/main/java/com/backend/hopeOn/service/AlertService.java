package com.backend.hopeOn.service;

import com.backend.hopeOn.domain.Alert;
import com.backend.hopeOn.generic.HOResponse;

import java.util.List;

public interface AlertService {
    HOResponse<String> save(String message, Long driverId);
    HOResponse<List<Alert>> findAllByDriverId(Long driverId);
}