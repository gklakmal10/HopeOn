package com.backend.hopeOn.service;

import com.backend.hopeOn.domain.GradeClass;
import com.backend.hopeOn.generic.HOResponse;

import java.util.List;

public interface GradeClassService {
    HOResponse<List<GradeClass>> findAll();
    HOResponse<GradeClass> save(GradeClass gradeClass);
    HOResponse<GradeClass> update(GradeClass gradeClass);
    HOResponse<String> delete(Long id);
}
