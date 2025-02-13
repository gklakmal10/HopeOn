package com.backend.hopeOn.repository;

import com.backend.hopeOn.entity.Vehicle;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface VehicleRepository extends JpaRepository<Vehicle, Long>, JpaSpecificationExecutor<Vehicle> {
    List<Vehicle> findAllByActiveIsTrue();
    Optional<Vehicle> findByIdAndActiveIsTrue(Long id);
    Optional<Vehicle> findByDriver_IdAndActiveIsTrue(Long id);
}
