package com.backend.hopeOn.service;

import com.backend.hopeOn.domain.Schedule;
import com.backend.hopeOn.entity.Student;
import com.backend.hopeOn.generic.HOResponse;
import com.backend.hopeOn.repository.ScheduleRepository;
import com.backend.hopeOn.repository.StudentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ScheduleServiceImpl implements ScheduleService{
    private final ScheduleRepository scheduleRepository;
    private final StudentRepository studentRepository;
    @Override
    public HOResponse<String> save(Schedule schedule) {
        HOResponse<String> response = new HOResponse<>();
        if(schedule.getDate() == null){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Date cannot be empty");
            return response;
        }
        if(schedule.getStudentId() == null){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("StudentId cannot be empty");
            return response;
        }
        if(schedule.getToHome() == null){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("To Home cannot be empty");
            return response;
        }
        if(schedule.getToSchool() == null){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("To School cannot be empty");
            return response;
        }

        Optional<com.backend.hopeOn.entity.Schedule> optionalSchedule = scheduleRepository.findByDateAndStudent_Id(schedule.getDate(), schedule.getStudentId());

        if(optionalSchedule.isPresent()){
            com.backend.hopeOn.entity.Schedule existingSchedule = optionalSchedule.get();
            existingSchedule.setToSchool(schedule.getToSchool());
            existingSchedule.setToHome(schedule.getToHome());

            scheduleRepository.save(existingSchedule);

        }else{
            com.backend.hopeOn.entity.Schedule scheduleEntity = new com.backend.hopeOn.entity.Schedule();
            scheduleEntity.setDate(schedule.getDate());

            Optional<Student> student = studentRepository.findByIdAndActiveIsTrue(schedule.getStudentId());

            if (student.isEmpty()){
                response.setStatus(HttpStatus.BAD_REQUEST.value());
                response.setMessage("Student not found");
                return response;
            }

            scheduleEntity.setStudent(student.get());
            scheduleEntity.setToHome(schedule.getToHome());
            scheduleEntity.setToSchool(schedule.getToSchool());

            scheduleRepository.save(scheduleEntity);
        }



        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Schedule Saved");
        return response;
    }

    @Override
    public HOResponse<List<Schedule>> findAllSchedule(Long studentId) {
        HOResponse<List<Schedule>> response = new HOResponse<>();
        if(studentId == null){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("StudentId cannot be empty");
            return response;
        }
        List<Schedule> schedules = scheduleRepository.findAllByStudent_Id(studentId).stream().map(this::EntityToDomainMapper).toList();

        response.setStatus(HttpStatus.OK.value());
        response.setObject(schedules);
        return response;
    }

    private Schedule EntityToDomainMapper(com.backend.hopeOn.entity.Schedule schedule){
        Schedule scheduleDomain = new Schedule();
        scheduleDomain.setId(schedule.getId());
        scheduleDomain.setDate(schedule.getDate());
        scheduleDomain.setStudentId(schedule.getStudent().getId());
        scheduleDomain.setToHome(schedule.getToHome());
        scheduleDomain.setToSchool(schedule.getToSchool());

        return scheduleDomain;
    }
}
