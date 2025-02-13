package com.backend.hopeOn.service;

import com.backend.hopeOn.enums.UserType;
import com.backend.hopeOn.generic.HOResponse;
import jakarta.mail.MessagingException;

public interface EmailService {
    void sendOtpEmail(String toEmail, UserType type) throws MessagingException;
    HOResponse<Boolean> verifyOtp(String email, String enteredOtp);

    void sendCredentials(String userName, String password) throws MessagingException;
}
