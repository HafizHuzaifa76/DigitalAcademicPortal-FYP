import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/shared/data/models/PreviousCourseGradeModel.dart';
import '../../domain/entities/Grade.dart';
import '../../domain/repositories/TeacherGradeRepository.dart';
import '../datasources/TeacherGradeRemoteDataSource.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';

class TeacherGradeRepositoryImpl implements TeacherGradeRepository {
  final TeacherGradeRemoteDataSource remoteDataSource;

  TeacherGradeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Fail, List<Grade>>> getCourseGrades(
      TeacherCourse course) async {
    try {
      final grades = await remoteDataSource.getCourseGrades(course);
      return Right(grades);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, void>> createCourseGrade(
      TeacherCourse course, Grade grade) async {
    try {
      await remoteDataSource.createCourseGrade(course, grade);
      return const Right(null);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, Map<String, dynamic>>> getMarkingGrades(
      TeacherCourse course, String gradeId) async {
    try {
      final marks = await remoteDataSource.getMarkingGrades(course, gradeId);
      return Right(marks);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, void>> saveMarkingGrades(TeacherCourse course,
      String gradeId, Map<String, dynamic> obtainedGrades) async {
    try {
      await remoteDataSource.saveMarkingGrades(course, gradeId, obtainedGrades);
      return const Right(null);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, void>> deleteGrade(
      TeacherCourse course, String gradeId) async {
    try {
      await remoteDataSource.deleteGrade(course, gradeId);
      return const Right(null);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, void>> updateGrade(
      TeacherCourse course, Grade grade) async {
    try {
      await remoteDataSource.updateGrade(course, grade);
      return const Right(null);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, void>> submitCourseGrades(
      List<PreviousCourseGradeModel> grades, TeacherCourse course) async {
    try {
      await remoteDataSource.submitCourseGrades(grades, course);
      return const Right(null);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }
}
