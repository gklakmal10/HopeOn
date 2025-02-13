package com.backend.hopeOn.service;

import com.backend.hopeOn.domain.GradeClass;
import com.backend.hopeOn.generic.HOException;
import com.backend.hopeOn.generic.HOResponse;
import com.backend.hopeOn.repository.GradeClassRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class GradeClassServiceImpl implements GradeClassService {

    private final GradeClassRepository gradeClassRepository;

    @Override
    public HOResponse<List<GradeClass>> findAll() {
        List<GradeClass> gradeClasses = gradeClassRepository.findAll().stream()
                .map(this::entityToDomainMapper)
                .toList();

        HOResponse<List<GradeClass>> response = new HOResponse<>();
        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Grade classes retrieved successfully");
        response.setObject(gradeClasses);

        return response;
    }

    @Override
    public HOResponse<GradeClass> save(GradeClass gradeClass) {
        if (gradeClass.getGrade() == null || gradeClass.getGrade().isBlank()) {
            throw new HOException("Grade cannot be empty");
        }
        if (gradeClass.getClasses() == null || gradeClass.getClasses().isBlank()) {
            throw new HOException("Class cannot be empty");
        }

        com.backend.hopeOn.entity.GradeClass savedEntity = gradeClassRepository.save(domainToEntityMapper(gradeClass));

        HOResponse<GradeClass> response = new HOResponse<>();
        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Grade class saved successfully");
        response.setObject(entityToDomainMapper(savedEntity));

        return response;
    }

    @Override
    public HOResponse<GradeClass> update(GradeClass gradeClass) {
        if (gradeClass.getId() == null) {
            throw new HOException("Grade class ID is required for update");
        }

        com.backend.hopeOn.entity.GradeClass existingEntity = gradeClassRepository.findById(gradeClass.getId())
                .orElseThrow(() -> new HOException("Grade class not found with ID: " + gradeClass.getId()));

        existingEntity.setGrade(gradeClass.getGrade());
        existingEntity.setClasses(gradeClass.getClasses());

        com.backend.hopeOn.entity.GradeClass updatedEntity = gradeClassRepository.save(existingEntity);

        HOResponse<GradeClass> response = new HOResponse<>();
        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Grade class updated successfully");
        response.setObject(entityToDomainMapper(updatedEntity));

        return response;
    }

    @Override
    public HOResponse<String> delete(Long id) {
        if (id == null) {
            throw new HOException("ID is required for deletion");
        }

        gradeClassRepository.deleteById(id);

        HOResponse<String> response = new HOResponse<>();
        response.setStatus(HttpStatus.OK.value());
        response.setMessage("Grade class deleted successfully");
        response.setObject("Deleted ID: " + id);

        return response;
    }

    private GradeClass entityToDomainMapper(com.backend.hopeOn.entity.GradeClass entity) {
        if (entity == null) {
            return null;
        }

        GradeClass domain = new GradeClass();
        domain.setId(entity.getId());
        domain.setGrade(entity.getGrade());
        domain.setClasses(entity.getClasses());

        return domain;
    }

    private com.backend.hopeOn.entity.GradeClass domainToEntityMapper(GradeClass domain) {
        if (domain == null) {
            return null;
        }

        com.backend.hopeOn.entity.GradeClass entity = new com.backend.hopeOn.entity.GradeClass();
        entity.setGrade(domain.getGrade());
        entity.setClasses(domain.getClasses());

        return entity;
    }
}
