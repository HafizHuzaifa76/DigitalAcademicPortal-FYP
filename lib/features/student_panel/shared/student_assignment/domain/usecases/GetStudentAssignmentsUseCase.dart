import 'package:dartz/dartz.dart';
import '../entities/StudentAssignment.dart';
import '../../../student_courses/domain/entities/StudentCourse.dart';
import '../repositories/StudentAssignmentRepository.dart';
import '../../../../../../core/usecases/UseCase.dart';

class GetStudentAssignmentsUseCase
    implements UseCase<List<StudentAssignment>, StudentCourse> {
  final StudentAssignmentRepository repository;
  GetStudentAssignmentsUseCase(this.repository);

  @override
  Future<Either<Fail, List<StudentAssignment>>> execute(
      StudentCourse course) async {
    return await repository.getAssignments(course);
  }
}
