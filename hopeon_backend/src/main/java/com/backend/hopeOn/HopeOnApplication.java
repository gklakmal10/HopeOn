package com.backend.hopeOn;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;

@SpringBootApplication
public class HopeOnApplication {

    public static void main(String[] args) {
        new SpringApplicationBuilder(HopeOnApplication.class)
                .properties("server.servlet.context-path=/api/v1")
                .run(args);
    }

}
