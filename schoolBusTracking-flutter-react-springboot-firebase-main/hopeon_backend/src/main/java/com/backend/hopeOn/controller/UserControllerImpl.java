package com.backend.hopeOn.controller;

import com.backend.hopeOn.domain.User;
import com.backend.hopeOn.generic.HOResponse;
import com.backend.hopeOn.request.PasswordResetRequest;
import com.backend.hopeOn.response.AuthResponse;
import com.backend.hopeOn.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
@CrossOrigin(origins = "http://localhost:50702")
public class UserControllerImpl implements UserController{
    private final UserService userService;

    @Override
    public HOResponse<AuthResponse> login(User user) {
        return userService.login(user);
    }

    @Override
    public HOResponse<String> resetPassword(PasswordResetRequest passwordResetRequest) {
        return userService.resetPassword(passwordResetRequest);
    }
}
