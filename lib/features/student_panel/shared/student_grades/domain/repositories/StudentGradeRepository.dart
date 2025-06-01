import 'package:dartz/dartz.dart';
import '../entities/StudentGrade.dart';

abstract class StudentGradeRepository {
  Future<Either<Fail, List<StudentGrade>>> getStudentGrades(
      String studentId, String courseId);
  Future<Either<Fail, List<StudentGrade>>> getAllGrades(String studentId);
}
