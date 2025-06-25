import 'package:dartz/dartz.dart';
import '../repositories/TeacherGradeRepository.dart';
import '../../../../../../shared/data/models/PreviousCourseGradeModel.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';

class SubmitCourseGradesParams {
  final List<PreviousCourseGradeModel> grades;
  final TeacherCourse course;

  SubmitCourseGradesParams({
    required this.grades,
    required this.course,
  });
}

class SubmitCourseGradesUseCase {
  final TeacherGradeRepository repository;
  SubmitCourseGradesUseCase(this.repository);

  Future<Either<Fail, void>> execute(SubmitCourseGradesParams params) {
    return repository.submitCourseGrades(params.grades, params.course);
  }
}
