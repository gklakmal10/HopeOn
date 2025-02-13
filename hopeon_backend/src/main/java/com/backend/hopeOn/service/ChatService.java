package com.backend.hopeOn.service;
import com.backend.hopeOn.entity.*;
import com.backend.hopeOn.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
@Service
@RequiredArgsConstructor
public class ChatService {
    private final ChatRepository chatRepository;
    private final MessageRepository messageRepository;
    private final UserRepository userRepository;

    public com.backend.hopeOn.domain.Message sendMessage(com.backend.hopeOn.domain.Message messageDomain) {
        Message message = new Message();
        message.setContent(messageDomain.getContent());
        message.setTimestamp(LocalDateTime.now());
        message.setSender(userRepository.findById(messageDomain.getSenderId()).orElseThrow());
        message.setReceiver(userRepository.findById(messageDomain.getReceiverId()).orElseThrow());
        message.setGlobalMessage(messageDomain.isGlobalMessage());
        message.setRead(false);

        Message savedMessage = messageRepository.save(message);
        return toDTO(savedMessage);
    }

    public List<com.backend.hopeOn.domain.Chat> getDriverChats(Long driverId) {
        return chatRepository.findByDriverId(driverId).stream()
                .map(this::convertToChatDomain).toList();
    }

    public List<com.backend.hopeOn.domain.Message> getChatMessages(Long senderId, Long receiverId) {
        List<Message> messages =  messageRepository.findBySenderIdAndReceiverIdOrderByTimestampDesc(senderId, receiverId);
        return messages.stream()
                .map(this::toDTO).toList();
    }

    public List<com.backend.hopeOn.domain.Message> getGlobalMessages() {
        List<Message> messages =  messageRepository.findByIsGlobalMessageOrderByTimestampDesc(true);
        return messages.stream()
                .map(this::toDTO).toList();
    }

    private com.backend.hopeOn.domain.Chat convertToChatDomain(Chat chat) {
        com.backend.hopeOn.domain.Chat dto = new com.backend.hopeOn.domain.Chat();
        dto.setId(chat.getId());
        dto.setDriverId(chat.getDriver().getId());
        dto.setStudentId(chat.getStudent().getId());

        // Get the latest message
        Message latestMessage = chat.getMessages().stream()
                .max(Comparator.comparing(Message::getTimestamp))
                .orElse(null);

        if (latestMessage != null) {
            dto.setLastMessage(latestMessage.getContent());
            dto.setLastMessageTime(latestMessage.getTimestamp());
        }

        // Count unread messages
        int unreadCount = (int) chat.getMessages().stream()
                .filter(message -> !message.isRead() &&
                        message.getReceiver().getId().equals(chat.getDriver().getId()))
                .count();

        dto.setUnreadCount(unreadCount);

        return dto;
    }

    private String getSenderImageUrl(Message message) {
        if (message.getSender() instanceof Driver) {
            return ((Driver) message.getSender()).getImageUrl();
        } else if (message.getSender() instanceof Student) {
            // You might want to return parent's image instead
            return ((Student) message.getSender()).getImageUrl();
        }
        return null;
    }

    private com.backend.hopeOn.domain.Message toDTO(Message message) {
        if (message == null) {
            return null;
        }

        com.backend.hopeOn.domain.Message dto = new com.backend.hopeOn.domain.Message();
        dto.setId(message.getId());
        dto.setContent(message.getContent());
        dto.setTimestamp(message.getTimestamp());
        dto.setSenderId(message.getSender().getId());
        dto.setReceiverId(message.getReceiver().getId());
        dto.setGlobalMessage(message.isGlobalMessage());
        dto.setRead(message.isRead());

        // Additional user information for UI
        dto.setSenderName(message.getSender().getFullName());
        dto.setReceiverName(message.getReceiver().getFullName());
        dto.setSenderImageUrl(getSenderImageUrl(message));

        return dto;
    }
}
