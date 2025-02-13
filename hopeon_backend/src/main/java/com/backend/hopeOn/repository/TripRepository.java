package com.backend.hopeOn.repository;

import com.backend.hopeOn.entity.Trip;
import com.backend.hopeOn.enums.AttendanceType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.Optional;

@Repository
public interface TripRepository extends JpaRepository<Trip, Long>, JpaSpecificationExecutor<Trip> {

    boolean existsByDateAndTypeAndDriver_Id(LocalDate date, AttendanceType type, Long driverId);

    Optional<Trip> findByDateAndTypeAndDriver_Id(LocalDate date, AttendanceType type, Long driverId);

}
