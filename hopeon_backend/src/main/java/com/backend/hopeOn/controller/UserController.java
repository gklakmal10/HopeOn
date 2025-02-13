package com.backend.hopeOn.controller;

import com.backend.hopeOn.domain.User;
import com.backend.hopeOn.generic.HOResponse;
import com.backend.hopeOn.request.PasswordResetRequest;
import com.backend.hopeOn.response.AuthResponse;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;

public interface UserController {
    @PostMapping("/auth")
    HOResponse<AuthResponse> login(@RequestBody User user);
    @PutMapping("/reset-password")
    HOResponse<String> resetPassword(@RequestBody PasswordResetRequest passwordResetRequest);
}
