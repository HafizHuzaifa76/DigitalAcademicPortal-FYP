import 'package:dartz/dartz.dart';
import '../entities/PreviousCourseGrade.dart';

abstract class PreviousCourseGradeRepository {
  Future<Either<Fail, List<PreviousCourseGrade>>> getPreviousCourseGrades(
      String studentId);
  Future<Either<Fail, List<PreviousCourseGrade>>> getPreviousSemesterGrades(
      String studentId, String semester);
}
