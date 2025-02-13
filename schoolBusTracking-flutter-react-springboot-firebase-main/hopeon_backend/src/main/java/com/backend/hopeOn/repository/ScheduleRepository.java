package com.backend.hopeOn.repository;

import com.backend.hopeOn.entity.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ScheduleRepository extends JpaRepository<Schedule, Long>, JpaSpecificationExecutor<Schedule> {
    List<Schedule> findAllByStudent_Id(Long studentId);
    Optional<Schedule> findByDateAndStudent_Id(LocalDate date, Long studentId);

    List<Schedule> findAllByDateAndToHomeIsTrueAndStudent_Vehicle_Driver_Id(LocalDate date, Long driverId);
    List<Schedule> findAllByDateAndToSchoolIsTrueAndStudent_Vehicle_Driver_Id(LocalDate date, Long driverId);
}
