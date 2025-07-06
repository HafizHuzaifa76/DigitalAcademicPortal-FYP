import 'package:dartz/dartz.dart';
import '../entities/StudentAssignment.dart';
import '../../../student_courses/domain/entities/StudentCourse.dart';
import '../../../../../../core/usecases/UseCase.dart';

abstract class StudentAssignmentRepository {
  Future<Either<Fail, List<StudentAssignment>>> getAssignments(
      StudentCourse course);
  Future<Either<Fail, void>> submitAssignment(
      String assignmentId, String fileUrl);
}
