package com.backend.hopeOn.repository;

import com.backend.hopeOn.entity.Message;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;
@Repository
public interface MessageRepository extends JpaRepository<Message, Long>, JpaSpecificationExecutor<Message> {
    List<Message> findBySenderIdAndReceiverIdOrderByTimestampDesc(Long senderId, Long receiverId);
    List<Message> findByIsGlobalMessageOrderByTimestampDesc(boolean isGlobal);
}
