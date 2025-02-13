package com.backend.hopeOn.service;

import com.backend.hopeOn.domain.Driver;
import com.backend.hopeOn.domain.Student;
import com.backend.hopeOn.generic.HOResponse;
import jakarta.mail.MessagingException;

import java.util.List;

public interface StudentService {
    HOResponse<List<Student>> findAll();
    HOResponse<Student> findById(Long id);
    HOResponse<List<Student>> search(Student studentSearch);
    HOResponse<Student> save(Student student) throws MessagingException;
    HOResponse<Student> assignVehicle(Long id, Long vehicleId);
    HOResponse<Student> update(Student student);
    HOResponse<String> delete(Long id);
}
