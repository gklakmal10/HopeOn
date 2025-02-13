package com.backend.hopeOn.controller;

import com.backend.hopeOn.domain.GradeClass;
import com.backend.hopeOn.generic.HOResponse;
import org.springframework.web.bind.annotation.*;

import java.util.List;

public interface GradeClassController {

    @GetMapping
    @ResponseBody
    HOResponse<List<GradeClass>> findAll();

    @PostMapping
    @ResponseBody
    HOResponse<GradeClass> save(@RequestBody GradeClass gradeClass);

    @PutMapping
    @ResponseBody
    HOResponse<GradeClass> update(@RequestBody GradeClass gradeClass);

    @DeleteMapping
    @ResponseBody
    HOResponse<String> delete(@RequestParam Long id);
}
