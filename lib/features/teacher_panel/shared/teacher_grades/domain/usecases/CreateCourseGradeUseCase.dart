import 'package:dartz/dartz.dart';
import '../../../../../../core/usecases/UseCase.dart';
import '../entities/Grade.dart';
import '../repositories/TeacherGradeRepository.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';

class CreateCourseGradeParams {
  final TeacherCourse course;
  final Grade grade;

  CreateCourseGradeParams({
    required this.course,
    required this.grade,
  });
}

class CreateCourseGradeUseCase
    implements UseCase<void, CreateCourseGradeParams> {
  final TeacherGradeRepository repository;

  CreateCourseGradeUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(CreateCourseGradeParams params) async {
    return await repository.createCourseGrade(params.course, params.grade);
  }
}
