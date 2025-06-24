import 'package:dartz/dartz.dart';

import '../../../../../../core/usecases/UseCase.dart';
import '../entities/Grade.dart';
import '../repositories/TeacherGradeRepository.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';

class CreateGradeParams {
  final TeacherCourse course;
  final Grade grade;

  CreateGradeParams({
    required this.course,
    required this.grade,
  });
}

class CreateGradeUseCase implements UseCase<void, CreateGradeParams> {
  final TeacherGradeRepository repository;

  CreateGradeUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(CreateGradeParams params) async {
    return await repository.createCourseGrade(params.course, params.grade);
  }
}
