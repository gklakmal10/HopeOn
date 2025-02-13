package com.backend.hopeOn.response;

import com.backend.hopeOn.domain.AbstractModel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class StudentResponse{
    private Long id;
    private String regNo;
    private String fullName;
    private String grade;
    private String studentClass;
    private String parentName;
    private String contactNo;
    private String gender;
    private Integer age;
    private String location;
    private String imageUrl;
    private Boolean active;
}
