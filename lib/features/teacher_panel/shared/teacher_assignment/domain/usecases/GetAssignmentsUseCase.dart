import 'package:dartz/dartz.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import '../entities/Assignment.dart';
import '../repositories/TeacherAssignmentRepository.dart';

class GetAssignmentsUseCase {
  final TeacherAssignmentRepository repository;

  GetAssignmentsUseCase(this.repository);

  Future<Either<Fail, List<Assignment>>> call(TeacherCourse course) async {
    return await repository.getAssignments(course);
  }
}
