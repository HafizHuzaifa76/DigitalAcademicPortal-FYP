import 'package:dartz/dartz.dart';
import '../entities/Assignment.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';

abstract class TeacherAssignmentRepository {
  Future<Either<Fail, List<Assignment>>> getAssignments(TeacherCourse course);
  Future<Either<Fail, void>> createAssignment(
      TeacherCourse course, Assignment assignment);
}
