package com.backend.hopeOn.generic;

import lombok.NoArgsConstructor;
import org.springframework.http.HttpStatus;

@NoArgsConstructor
public class HOException extends RuntimeException{
    public HttpStatus status = null;
    public HOException(String message){
        super(message);
    }
    public HOException(String message, HttpStatus status){
        this(message);
        this.status = status;
    }
}
