package com.backend.hopeOn.response;

import com.backend.hopeOn.domain.AbstractModel;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AttendanceResponse extends AbstractModel {
    private String fullName;
    private String regNo;
    private String grade;
    private String studentClass;
    private String imageUrl;
    private Boolean attendance;
}
