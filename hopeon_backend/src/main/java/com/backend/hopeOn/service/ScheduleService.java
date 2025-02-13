package com.backend.hopeOn.service;

import com.backend.hopeOn.domain.Schedule;
import com.backend.hopeOn.generic.HOResponse;

import java.util.List;

public interface ScheduleService {

    HOResponse<String> save(Schedule schedule);
    HOResponse<List<Schedule>> findAllSchedule(Long studentId);



}
