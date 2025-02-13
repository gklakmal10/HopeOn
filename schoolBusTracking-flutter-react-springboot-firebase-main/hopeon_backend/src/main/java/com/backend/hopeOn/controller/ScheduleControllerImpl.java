package com.backend.hopeOn.controller;

import com.backend.hopeOn.domain.Schedule;
import com.backend.hopeOn.generic.HOResponse;
import com.backend.hopeOn.service.ScheduleService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/schedule")
@RequiredArgsConstructor
public class ScheduleControllerImpl implements ScheduleController{
    private final ScheduleService scheduleService;
    @Override
    public HOResponse<String> save(Schedule schedule) {
        try {
            return scheduleService.save(schedule);
        }catch (Exception e) {
            HOResponse<String> response = new HOResponse<>();
            response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
            response.setMessage(e.getMessage());
            return response;
        }
    }

    @Override
    public HOResponse<List<Schedule>> findAllSchedule(Long studentId) {
        try {
            return scheduleService.findAllSchedule(studentId);
        }catch (Exception e) {
            HOResponse<List<Schedule>> response = new HOResponse<>();
            response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
            response.setMessage(e.getMessage());
            return response;
        }
    }
}
