import 'package:dartz/dartz.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import '../entities/Assignment.dart';
import '../repositories/TeacherAssignmentRepository.dart';

class CreateAssignmentUseCase {
  final TeacherAssignmentRepository repository;

  CreateAssignmentUseCase(this.repository);

  Future<Either<Fail, void>> execute(
      TeacherCourse course, Assignment assignment) async {
    return await repository.createAssignment(course, assignment);
  }
}
