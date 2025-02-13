package com.backend.hopeOn.controller;

import com.backend.hopeOn.domain.Schedule;
import com.backend.hopeOn.generic.HOResponse;
import org.springframework.web.bind.annotation.*;

import java.util.List;

public interface ScheduleController {
    @PostMapping
    @ResponseBody
    HOResponse<String> save(@RequestBody Schedule schedule);

    @GetMapping
    @ResponseBody
    HOResponse<List<Schedule>> findAllSchedule(@RequestParam Long studentId);
}
