package com.backend.hopeOn.generic;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class HOResponse<L> implements Serializable {
    private int status;
    private String message;
    private L object;
}
