package com.backend.hopeOn.repository;

import com.backend.hopeOn.entity.Student;
import com.backend.hopeOn.response.StudentResponse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StudentRepository extends JpaRepository<Student, Long>, JpaSpecificationExecutor<Student> {

    List<Student> findAllByActiveIsTrue();
    Optional<Student> findByIdAndActiveIsTrue(Long id);
    Optional<Student> findByRegNoAndActiveIsTrue(String regNo);


//    @Query("SELECT new com.backend.hopeOn.response.StudentResponse(s.id, s.regNo, s.fullName, s.grade, s.studentClass, s.parentName, s.contactNo, s.gender, s.age, s.location, s.imageUrl, s.active) " +
//            "FROM student s " +
//            "WHERE s.id = :id AND s.active = true")
//    StudentResponse findActiveStudentById(@Param("id") Long id);
}
