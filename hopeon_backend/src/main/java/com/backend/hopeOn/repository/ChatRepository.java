package com.backend.hopeOn.repository;

import com.backend.hopeOn.entity.Chat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
@Repository
public interface ChatRepository extends JpaRepository<Chat, Long> {
    List<Chat> findByDriverId(Long driverId);
    Chat findByDriverIdAndStudentId(Long driverId, Long studentId);
}
