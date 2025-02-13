package com.backend.hopeOn.repository;

import com.backend.hopeOn.entity.GradeClass;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface GradeClassRepository extends JpaRepository<GradeClass, Long>, JpaSpecificationExecutor<GradeClass> {
}
