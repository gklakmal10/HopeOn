package com.backend.hopeOn.controller;

import com.backend.hopeOn.enums.UserType;
import com.backend.hopeOn.generic.HOResponse;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

public interface EmailController {
    @GetMapping("/send-otp")
    @ResponseBody
    String sendOtp(@RequestParam String email, @RequestParam UserType type);

    @PostMapping("/verify-otp")
    @ResponseBody
    HOResponse<Boolean> verifyOtp(@RequestParam String email, @RequestParam String otp);
}
