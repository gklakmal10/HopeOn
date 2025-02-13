package com.backend.hopeOn.controller;

import com.backend.hopeOn.domain.GradeClass;
import com.backend.hopeOn.generic.HOException;
import com.backend.hopeOn.generic.HOResponse;
import com.backend.hopeOn.service.GradeClassService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/gradeClass")
@RequiredArgsConstructor
public class GradeClassControllerImpl implements GradeClassController {

    private final GradeClassService gradeClassService;

    @Override
    public HOResponse<List<GradeClass>> findAll() {
        try {
            return gradeClassService.findAll();
        } catch (Exception e) {
            throw new HOException(e.getMessage());
        }
    }

    @Override
    public HOResponse<GradeClass> save(GradeClass gradeClass) {
        try {
            return gradeClassService.save(gradeClass);
        } catch (Exception e) {
            throw new HOException(e.getMessage());
        }
    }

    @Override
    public HOResponse<GradeClass> update(GradeClass gradeClass) {
        try {
            return gradeClassService.update(gradeClass);
        } catch (Exception e) {
            throw new HOException(e.getMessage());
        }
    }

    @Override
    public HOResponse<String> delete(Long id) {
        try {
            return gradeClassService.delete(id);
        } catch (Exception e) {
            throw new HOException(e.getMessage());
        }
    }
}
