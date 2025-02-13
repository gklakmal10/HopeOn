package com.backend.hopeOn.service;

import com.backend.hopeOn.domain.User;
import com.backend.hopeOn.generic.HOException;
import com.backend.hopeOn.generic.HOResponse;
import com.backend.hopeOn.repository.UserRepository;
import com.backend.hopeOn.request.PasswordResetRequest;
import com.backend.hopeOn.response.AuthResponse;
import com.backend.hopeOn.util.PasswordHashingUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;


    @Override
    public HOResponse<AuthResponse> login(User user) {
        PasswordHashingUtil passwordHashingUtil = new PasswordHashingUtil();

        Optional<com.backend.hopeOn.entity.User> optionalUser = userRepository.findByEmailAndTypeAndActiveIsTrue(user.getEmail(), user.getType());

        if(optionalUser.isEmpty()) throw new HOException("Bad credentials");

        com.backend.hopeOn.entity.User existingUser = optionalUser.get();
        if(!passwordHashingUtil.verifyPassword(user.getPassword(), existingUser.getPassword())){
            throw new HOException("Bad credentials");
        }

        HOResponse<AuthResponse> response = new HOResponse<>();
        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Authentication successful");

        AuthResponse authResponse = new AuthResponse();
        authResponse.setId(existingUser.getId());
        authResponse.setEmail(existingUser.getEmail());
        authResponse.setFullName(existingUser.getFullName());
        authResponse.setType(existingUser.getType());

        response.setObject(authResponse);

        return response;
    }

    @Override
    public HOResponse<String> resetPassword(PasswordResetRequest passwordResetRequest) {
        PasswordHashingUtil passwordHashingUtil = new PasswordHashingUtil();

        Optional<com.backend.hopeOn.entity.User> optionalUser = userRepository.findByEmailAndTypeAndActiveIsTrue(passwordResetRequest.getEmail(), passwordResetRequest.getType());

        if(optionalUser.isEmpty()) throw new HOException("Bad credentials");

        com.backend.hopeOn.entity.User existingUser = optionalUser.get();
        existingUser.setPassword(passwordHashingUtil.hashPassword(passwordResetRequest.getNewPassword()));


        userRepository.save(existingUser);

        HOResponse<String> response = new HOResponse<>();
        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Password reset successfully");
        return response;
    }
}
