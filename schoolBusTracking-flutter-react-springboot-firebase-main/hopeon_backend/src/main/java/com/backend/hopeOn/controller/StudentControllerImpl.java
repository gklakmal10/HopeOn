package com.backend.hopeOn.controller;

import com.backend.hopeOn.domain.Student;
import com.backend.hopeOn.generic.HOException;
import com.backend.hopeOn.generic.HOResponse;
import com.backend.hopeOn.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/student")
public class StudentControllerImpl implements StudentController{
    @Autowired
    private final StudentService studentService;

    public StudentControllerImpl(StudentService studentService) {
        this.studentService = studentService;
    }


    @Override
    public HOResponse<List<Student>> findAll() {
        try {
            return studentService.findAll();
        }catch (Exception e) {
            throw new HOException(e.getMessage());
        }
    }

    @Override
    public HOResponse<Student> save(Student student) {
        try {
            return studentService.save(student);
        }catch (Exception e){
            throw new HOException(e.getMessage());
        }
    }

    @Override
    public HOResponse<Student> findById(Long id) {
        try {
            return studentService.findById(id);
        }catch (Exception e){
            throw new HOException(e.getMessage());
        }
    }

    @Override
    public HOResponse<Student> update(Student student) {
        try {
            return studentService.update(student);
        }catch (Exception e){
            throw new HOException(e.getMessage());
        }
    }

    @Override
    public HOResponse<Student> assignVehicle(Long id, Long vehicleId) {
        try {
            return studentService.assignVehicle(id, vehicleId);
        }catch (Exception e){
            throw new HOException(e.getMessage());
        }
    }

}
