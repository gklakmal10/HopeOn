package com.backend.hopeOn.request;

import com.backend.hopeOn.enums.UserType;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PasswordResetRequest {
    private String email;
    private String newPassword;
    private UserType type;
}
