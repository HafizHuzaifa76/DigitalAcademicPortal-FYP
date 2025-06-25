import 'package:dartz/dartz.dart';

import '../../../../../../core/usecases/UseCase.dart';
import '../entities/Grade.dart';
import '../repositories/TeacherGradeRepository.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';

class GetCourseGradesUseCase {
  final TeacherGradeRepository repository;

  GetCourseGradesUseCase(this.repository);

  Future<Either<Fail, List<Grade>>> execute(TeacherCourse course) async {
    return await repository.getCourseGrades(course);
  }
}
