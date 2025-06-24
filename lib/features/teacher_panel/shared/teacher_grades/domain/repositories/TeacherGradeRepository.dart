import 'package:dartz/dartz.dart';
import '../entities/Grade.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import '../../../../../../shared/data/models/PreviousCourseGradeModel.dart';

abstract class TeacherGradeRepository {
  Future<Either<Fail, List<Grade>>> getCourseGrades(TeacherCourse course);

  Future<Either<Fail, void>> createCourseGrade(
      TeacherCourse course, Grade grade);

  Future<Either<Fail, Map<String, dynamic>>> getMarkingGrades(
    TeacherCourse course,
    String gradeId,
  );

  Future<Either<Fail, void>> saveMarkingGrades(
    TeacherCourse course,
    String gradeId,
    Map<String, dynamic> obtainedGrades,
  );

  Future<Either<Fail, void>> deleteGrade(TeacherCourse course, String gradeId);

  Future<Either<Fail, void>> updateGrade(TeacherCourse course, Grade grade);

  Future<Either<Fail, void>> submitCourseGrades(
      List<PreviousCourseGradeModel> grades, TeacherCourse course);
}
