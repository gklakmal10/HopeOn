package com.backend.hopeOn.domain;

import com.backend.hopeOn.enums.UserType;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class User extends AbstractModel{
    private String email;
    private String password;
    private UserType type;
    private String fullName;
    private Boolean active;
}
