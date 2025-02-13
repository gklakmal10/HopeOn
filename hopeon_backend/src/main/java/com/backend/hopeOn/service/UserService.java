package com.backend.hopeOn.service;

import com.backend.hopeOn.domain.User;
import com.backend.hopeOn.generic.HOResponse;
import com.backend.hopeOn.request.PasswordResetRequest;
import com.backend.hopeOn.response.AuthResponse;

public interface UserService {
    HOResponse<AuthResponse> login(User user);
    HOResponse<String> resetPassword(PasswordResetRequest passwordResetRequest);
}
