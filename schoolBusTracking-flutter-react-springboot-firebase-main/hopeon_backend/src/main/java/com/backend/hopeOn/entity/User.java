package com.backend.hopeOn.entity;

import com.backend.hopeOn.enums.UserType;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity(name = "user")
@Inheritance(strategy = InheritanceType.JOINED)
public class User extends AbstractEntity{
    @Column(name = "email")
    private String email;
    @Column(name = "password")
    private String password;
    @Column(name = "type")
    @Enumerated(EnumType.STRING)
    private UserType type;
    @Column(name = "full_name")
    private String fullName;
    @Column(name = "active")
    private Boolean active;
}
