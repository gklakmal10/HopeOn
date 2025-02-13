package com.backend.hopeOn.repository;

import com.backend.hopeOn.entity.Driver;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DriverRepository extends JpaRepository<Driver, Long>, JpaSpecificationExecutor<Driver> {
    List<Driver> findAllByActiveIsTrue();
    Optional<Driver> findByIdAndActiveIsTrue(Long id);
    Optional<Driver> findByNicNoAndActiveIsTrue(String nic);
}
