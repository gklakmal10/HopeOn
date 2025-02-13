package com.backend.hopeOn.response;

import com.backend.hopeOn.domain.AbstractModel;
import com.backend.hopeOn.enums.UserType;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AuthResponse extends AbstractModel {
    private String email;
    private UserType type;
    private String fullName;
}
