import 'package:dartz/dartz.dart';
import '../repositories/TeacherGradeRepository.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';

class GetMarkingGradesParams {
  final TeacherCourse course;
  final String gradeId;

  GetMarkingGradesParams({
    required this.course,
    required this.gradeId,
  });
}

class GetMarkingGradesUseCase {
  final TeacherGradeRepository repository;

  GetMarkingGradesUseCase(this.repository);

  Future<Either<Fail, Map<String, dynamic>>> execute(
      GetMarkingGradesParams params) async {
    return await repository.getMarkingGrades(params.course, params.gradeId);
  }
}
