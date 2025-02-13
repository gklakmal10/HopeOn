package com.backend.hopeOn.service;

import com.backend.hopeOn.entity.User;
import com.backend.hopeOn.enums.UserType;
import com.backend.hopeOn.generic.HOException;
import com.backend.hopeOn.generic.HOResponse;
import com.backend.hopeOn.repository.UserRepository;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.Map;
import java.util.Optional;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;

@Service
@RequiredArgsConstructor
public class EmailServiceImpl implements EmailService {

    @Autowired
    private JavaMailSender mailSender;
    private final UserRepository userRepository;

    @Value("${spring.mail.username}")
    private String fromAddress;

    private final Map<String, String> otpStorage = new ConcurrentHashMap<>();
    private final Map<String, Long> otpTimestamps = new ConcurrentHashMap<>();

    private static final long OTP_EXPIRY_TIME = TimeUnit.MINUTES.toMillis(5);

    public String generateOtp() {
        return String.format("%04d", new Random().nextInt(10000));
    }

    @Override
    public void sendOtpEmail(String toEmail, UserType type) throws MessagingException {
        if(!StringUtils.hasText(toEmail)){
            throw new HOException("Email cannot be empty");
        }

        Optional<User> user = userRepository.findByEmailAndTypeAndActiveIsTrue(toEmail, type);

        if(user.isEmpty()){
            throw new HOException("User not found");
        }

        String otp = generateOtp();

        otpStorage.put(toEmail, otp);
        otpTimestamps.put(toEmail, System.currentTimeMillis());

        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true);

        helper.setTo(toEmail);
        helper.setSubject("Your OTP Code");
        helper.setText("Your OTP code is: " + otp + "\nThis OTP will expire in 5 minutes.", true);
        helper.setFrom(fromAddress);

        mailSender.send(message);
    }
    @Override
    public HOResponse<Boolean> verifyOtp(String email, String enteredOtp) {
        HOResponse<Boolean> response = new HOResponse<>();
        if (!otpStorage.containsKey(email)) {
            response.setMessage("No OTP available");
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setObject(false);
            return response;
        }

        long storedTime = otpTimestamps.get(email);
        if (System.currentTimeMillis() - storedTime > OTP_EXPIRY_TIME) {
            otpStorage.remove(email);
            otpTimestamps.remove(email);

            response.setMessage("OTP code expired");
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setObject(false);
            return response;
        }

        boolean isValid = otpStorage.get(email).equals(enteredOtp);
        if (isValid) {
            otpStorage.remove(email);
            otpTimestamps.remove(email);
        }
        response.setMessage(isValid ? "OTP Verified" : "Invalid OTP");
        response.setStatus(isValid ? HttpStatus.OK.value() : HttpStatus.BAD_REQUEST.value());
        response.setObject(isValid);
        return response;
    }

    @Override
    public void sendCredentials(String userName, String password) throws MessagingException {
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true);

        helper.setTo(userName);
        helper.setSubject("Your HopeOn account Credentials");
        helper.setText("Your userName: " + userName + " and Password: "+password+". Reset the password after login to keep your account safe", true);
        helper.setFrom(fromAddress);

        mailSender.send(message);
    }
}
