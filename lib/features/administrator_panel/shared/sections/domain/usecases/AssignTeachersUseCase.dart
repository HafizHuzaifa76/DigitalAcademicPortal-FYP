import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';

import '../entities/Section.dart';
import '../repositories/SectionRepository.dart';

class AssignTeachersUseCase implements UseCase<void, AssignTeachersParams>{
  final SectionRepository repository;

  AssignTeachersUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(AssignTeachersParams params) async {
    return await repository.assignTeacherToCourses(params.deptName, params.semester, params.section, params.coursesTeachersMap);
  }
}

class EditAssignTeachersUseCase implements UseCase<void, EditAssignTeachersParams>{
  final SectionRepository repository;

  EditAssignTeachersUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(EditAssignTeachersParams params) async {
    return await repository.editAssignedTeachers(params.deptName, params.semester, params.section, params.courseName, params.teacher);
  }
}

class FetchAssignedTeachersUseCase implements UseCase<Map<String, String?>, FetchAssignedTeachersParams>{
  final SectionRepository repository;

  FetchAssignedTeachersUseCase(this.repository);

  @override
  Future<Either<Fail, Map<String, String?>>> execute(FetchAssignedTeachersParams params) async {
    return await repository.fetchAssignedTeachers(params.deptName, params.semester, params.section);
  }
}