package com.backend.hopeOn.controller;

import com.backend.hopeOn.enums.UserType;
import com.backend.hopeOn.generic.HOException;
import com.backend.hopeOn.generic.HOResponse;
import com.backend.hopeOn.service.EmailService;
import jakarta.mail.MessagingException;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/mail")
@RequiredArgsConstructor
public class EmailControllerImpl implements EmailController{
    private final EmailService emailService;
    @Override
    public String sendOtp(String email, UserType type) {
        try {
            emailService.sendOtpEmail(email, type);
            return "OTP sent successfully!";
        } catch (MessagingException e) {
            return "Failed to send OTP: " + e.getMessage();
        }
    }

    @Override
    public HOResponse<Boolean> verifyOtp(String email, String otp) {
        try {
            return emailService.verifyOtp(email, otp);
        }catch (Exception e){
            throw new HOException(e.getMessage());
        }
    }
}
