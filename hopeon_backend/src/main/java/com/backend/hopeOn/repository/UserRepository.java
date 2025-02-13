package com.backend.hopeOn.repository;

import com.backend.hopeOn.entity.Student;
import com.backend.hopeOn.entity.User;
import com.backend.hopeOn.enums.UserType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long>, JpaSpecificationExecutor<User> {
    Optional<User> findByEmailAndTypeAndActiveIsTrue(String email, UserType type);
}
