package com.backend.hopeOn.util;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
public class PasswordHashingUtil {
    private static final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    // Method to hash a password
    public  String hashPassword(String plainPassword) {
        return passwordEncoder.encode(plainPassword);
    }

    // Method to verify a password
    public  boolean verifyPassword(String plainPassword, String hashedPassword) {
        return passwordEncoder.matches(plainPassword, hashedPassword);
    }

}
