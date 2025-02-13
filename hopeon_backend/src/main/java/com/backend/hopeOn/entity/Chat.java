package com.backend.hopeOn.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.util.List;

@Entity
@Getter
@Setter
public class Chat extends AbstractEntity {
    @ManyToOne
    @JoinColumn(name = "driver_id")
    private Driver driver;

    @ManyToOne
    @JoinColumn(name = "student_id")
    private Student student;

    @OneToMany(cascade = CascadeType.ALL)
    private List<Message> messages;
}