package com.backend.hopeOn.controller;

import com.backend.hopeOn.domain.Chat;
import com.backend.hopeOn.domain.Message;
import com.backend.hopeOn.service.ChatService;
import org.springframework.web.bind.annotation.*;
import lombok.RequiredArgsConstructor;

import java.util.List;

@RestController
@RequestMapping("/api/chat")
@RequiredArgsConstructor
public class ChatController {
    private final ChatService chatService;

    @PostMapping("/message")
    public Message sendMessage(@RequestBody Message messageDTO) {
        return chatService.sendMessage(messageDTO);
    }

    @GetMapping("/driver/{driverId}/chats")
    public List<Chat> getDriverChats(@PathVariable Long driverId) {
        return chatService.getDriverChats(driverId);
    }

    @GetMapping("/messages/{senderId}/{receiverId}")
    public List<Message> getChatMessages(
            @PathVariable Long senderId,
            @PathVariable Long receiverId
    ) {
        return chatService.getChatMessages(senderId, receiverId);
    }

    @GetMapping("/messages/global")
    public List<Message> getGlobalMessages() {
        return chatService.getGlobalMessages();
    }
}
