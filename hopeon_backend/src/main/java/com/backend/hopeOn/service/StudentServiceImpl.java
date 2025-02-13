package com.backend.hopeOn.service;

import com.backend.hopeOn.domain.Student;
import com.backend.hopeOn.entity.Vehicle;
import com.backend.hopeOn.enums.UserType;
import com.backend.hopeOn.generic.HOException;
import com.backend.hopeOn.generic.HOResponse;
import com.backend.hopeOn.repository.StudentRepository;
import com.backend.hopeOn.repository.UserRepository;
import com.backend.hopeOn.repository.VehicleRepository;
import com.backend.hopeOn.util.PasswordHashingUtil;
import jakarta.mail.MessagingException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class StudentServiceImpl implements StudentService{
    private final UserRepository userRepository;
    private final StudentRepository studentRepository;
    private final VehicleRepository vehicleRepository;
    private final EmailService emailService;

    @Override
    public HOResponse<List<Student>> findAll() {

        List<Student> studentList = studentRepository.findAll().stream().map(this::StudentEntityToDomainMapper).toList();

        HOResponse<List<Student>> response = new HOResponse<>();
        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Student List get successfully");
        response.setObject(studentList);

        return response;
    }

    @Override
    public HOResponse<Student> findById(Long id) {
        HOResponse<Student> response = new HOResponse<>();

        Optional<com.backend.hopeOn.entity.Student> optionalStudent = studentRepository.findByIdAndActiveIsTrue(id);
        if(optionalStudent.isEmpty()){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Student not found");
            return response;
        }

        response.setStatus(HttpStatus.OK.value());
        response.setObject(StudentEntityToDomainMapper(optionalStudent.get()));

        return response;
    }

    @Override
    public HOResponse<List<Student>> search(Student studentSearch) {
        return null;
    }

    @Override
    public HOResponse<Student> save(Student student) throws MessagingException {
        HOResponse<Student> response =  new HOResponse<>();

        if(!StringUtils.hasText(student.getRegNo())){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Student registration number cannot be empty");
            return response;
        }
        if(!StringUtils.hasText(student.getFullName())){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Student name cannot be empty");
            return response;
        }
        if(!StringUtils.hasText(student.getGrade())){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Student grade cannot be empty");
            return response;
        }
        if(!StringUtils.hasText(student.getStudentClass())){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Student class cannot be empty");
            return response;
        }
        if(!StringUtils.hasText(student.getParentName())){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Student parent name be empty");
            return response;
        }
        if(!StringUtils.hasText(student.getContactNo())){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Student contact no cannot be empty");
            return response;
        }
        Optional<com.backend.hopeOn.entity.Student> optionalStudent = studentRepository.findByRegNoAndActiveIsTrue(student.getRegNo());
        if(optionalStudent.isPresent()) {
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Student already has an account");
            return response;
        }

        com.backend.hopeOn.entity.Student newStudent = userRepository.save(DomainToEntityMapper(student));

        emailService.sendCredentials(student.getEmail(), student.getPassword());

        response.setStatus(HttpStatus.OK.value());
        response.setObject(StudentEntityToDomainMapper(newStudent));
        response.setMessage("Student saved successfully");

        return response;
    }

    @Override
    public HOResponse<Student> assignVehicle(Long id, Long vehicleId) {
        HOResponse<Student> response = new HOResponse<>();

        Optional<com.backend.hopeOn.entity.Student> optionalStudent = studentRepository.findByIdAndActiveIsTrue(id);
        if(optionalStudent.isEmpty()){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Student not found");
            return response;
        }

        Optional<Vehicle> optionalVehicle = vehicleRepository.findByIdAndActiveIsTrue(vehicleId);
        if(optionalVehicle.isEmpty()){
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Vehicle not found");
            return response;
        }

        com.backend.hopeOn.entity.Student existingStudent = optionalStudent.get();
        Vehicle vehicle = optionalVehicle.get();

        existingStudent.setVehicle(vehicle);

        com.backend.hopeOn.entity.Student updatedStudent = studentRepository.save(existingStudent);

        vehicle.setAvailableSeatCount(vehicle.getAvailableSeatCount()-1);
        vehicleRepository.save(vehicle);

        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Vehicle assigned successfully");
        response.setObject(StudentEntityToDomainMapper(updatedStudent));

        return response;
    }

    @Override
    public HOResponse<Student> update(Student student) {
        HOResponse<Student> response = new HOResponse<>();

        // Check if student ID is provided
        if (student.getId() == null) {
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Student ID is required");
            return response;
        }

        // Fetch the existing student record from the database
        Optional<com.backend.hopeOn.entity.Student> optionalStudent = studentRepository.findById(student.getId());
        if (optionalStudent.isEmpty()) {
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("Student not found");
            return response;
        }

        // Get the existing student entity
        com.backend.hopeOn.entity.Student existingStudent = optionalStudent.get();

        // Update user fields (inherited from User class)
        existingStudent.setFullName(student.getFullName());
        existingStudent.setEmail(student.getEmail());
        existingStudent.setContactNo(student.getContactNo());
        existingStudent.setGender(student.getGender());
        existingStudent.setAge(student.getAge());
        existingStudent.setLocation(student.getLocation());
        existingStudent.setImageUrl(student.getImageUrl());
        existingStudent.setActive(student.getActive());

        // If a new password is provided, update it
        if (StringUtils.hasText(student.getPassword())) {
            PasswordHashingUtil passwordHashingUtil = new PasswordHashingUtil();
            existingStudent.setPassword(passwordHashingUtil.hashPassword(student.getPassword()));
        }

        // Update student-specific fields
        existingStudent.setRegNo(student.getRegNo());
        existingStudent.setGrade(student.getGrade());
        existingStudent.setStudentClass(student.getStudentClass());
        existingStudent.setParentName(student.getParentName());

        // Handle vehicle assignment (if provided)
        if (student.getVehicleId() != null) {
            Optional<Vehicle> optionalVehicle = vehicleRepository.findByIdAndActiveIsTrue(student.getVehicleId());
            if (optionalVehicle.isPresent()) {
                existingStudent.setVehicle(optionalVehicle.get());
            } else {
                response.setStatus(HttpStatus.BAD_REQUEST.value());
                response.setMessage("Vehicle not found with ID: " + student.getVehicleId());
                return response;
            }
        }

        // Save the updated student entity
        com.backend.hopeOn.entity.Student updatedStudent = studentRepository.save(existingStudent);

        // Prepare and send response
        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Student updated successfully");
        response.setObject(StudentEntityToDomainMapper(updatedStudent));

        return response;
    }


    @Override
    public HOResponse<String> delete(Long id) {
        return null;
    }

    public Student StudentEntityToDomainMapper(com.backend.hopeOn.entity.Student studentEntity) {
        if (studentEntity == null) {
            return null;
        }

        Student studentDomain = new Student();
        studentDomain.setId(studentEntity.getId());
        studentDomain.setEmail(studentEntity.getEmail());
        studentDomain.setType(studentEntity.getType());
        studentDomain.setRegNo(studentEntity.getRegNo());
        studentDomain.setFullName(studentEntity.getFullName());
        studentDomain.setGrade(studentEntity.getGrade());
        studentDomain.setStudentClass(studentEntity.getStudentClass());
        studentDomain.setParentName(studentEntity.getParentName());
        studentDomain.setContactNo(studentEntity.getContactNo());
        studentDomain.setGender(studentEntity.getGender());
        studentDomain.setAge(studentEntity.getAge());
        studentDomain.setLocation(studentEntity.getLocation());
        studentDomain.setImageUrl(studentEntity.getImageUrl());
        studentDomain.setActive(studentEntity.getActive());

        if (studentEntity.getVehicle() != null) {
            studentDomain.setVehicleId(studentEntity.getVehicle().getId());
            studentDomain.setVehicleNo(studentEntity.getVehicle().getVehicleNo());
            studentDomain.setVehicleDetails(studentEntity.getVehicle().getType()+", "+studentEntity.getVehicle().getBrand()+", "+studentEntity.getVehicle().getModel());

            if(studentEntity.getVehicle().getDriver() != null) {
                studentDomain.setDriverId(studentEntity.getVehicle().getDriver().getId());
                studentDomain.setDriverName(studentEntity.getVehicle().getDriver().getFullName());
                studentDomain.setDriverNIC(studentEntity.getVehicle().getDriver().getNicNo());
                studentDomain.setDriverContactNo(studentEntity.getVehicle().getDriver().getContactNo());
            }
        }

        //studentDomain.setSchedules(studentEntity.getSchedules());

        return studentDomain;
    }
    private com.backend.hopeOn.entity.Student DomainToEntityMapper(Student studentDomain) {
        if (studentDomain == null) {
            return null;
        }

        com.backend.hopeOn.entity.Student studentEntity = new com.backend.hopeOn.entity.Student();

        PasswordHashingUtil passwordHashingUtil = new PasswordHashingUtil();

        studentEntity.setRegNo(studentDomain.getRegNo());
        studentEntity.setEmail(studentDomain.getEmail());
        studentEntity.setPassword(passwordHashingUtil.hashPassword(studentDomain.getPassword()));
        studentEntity.setType(UserType.STUDENT);
        studentEntity.setFullName(studentDomain.getFullName());
        studentEntity.setGrade(studentDomain.getGrade());
        studentEntity.setStudentClass(studentDomain.getStudentClass());
        studentEntity.setParentName(studentDomain.getParentName());
        studentEntity.setContactNo(studentDomain.getContactNo());
        studentEntity.setGender(studentDomain.getGender());
        studentEntity.setAge(studentDomain.getAge());
        studentEntity.setLocation(studentDomain.getLocation());
        studentEntity.setImageUrl(studentDomain.getImageUrl());
        if(studentDomain.getActive() != null){
            studentEntity.setActive(studentDomain.getActive());
        }else{
            studentEntity.setActive(false);
        }

        return studentEntity;
    }


}
