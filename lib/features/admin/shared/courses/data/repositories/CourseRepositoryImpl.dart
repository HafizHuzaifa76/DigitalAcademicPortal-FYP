
import 'package:dartz/dartz.dart';
import '../../domain/entities/Course.dart';
import '../../domain/repositories/CourseRepository.dart';
import '../datasources/CourseRemoteDataSource.dart';
import '../models/CourseModel.dart';

class CourseRepositoryImpl implements CourseRepository{
  final CourseRemoteDataSource courseRemoteDataSource;

  CourseRepositoryImpl({required this.courseRemoteDataSource});

  @override
  Future<Either<Fail, Course>> addCourse(String deptName, Course course) async {
    try {
      return Right(await courseRemoteDataSource.addCourse(deptName, CourseModel.fromCourse(course)));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+1);
      }
      return Left(Fail(message));
    }
  }

  @override
  Future<Either<Fail, void>> deleteCourse(String deptName, Course course) async {
    try {
      return Right(await courseRemoteDataSource.deleteCourse(deptName, course.courseCode));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+1);
      }
      return Left(Fail(message));
    }
  }

  @override
  Future<Either<Fail, Course>> editCourse(String deptName, Course course) async {
    try {
      return Right(await courseRemoteDataSource.editCourse(deptName, CourseModel.fromCourse(course)));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+2);
      }
      return Left(Fail(message));
    }
  }

  @override
  Future<Either<Fail, List<Course>>> showDeptCourses(String deptName) async {
    try {
      return Right(await courseRemoteDataSource.deptCourses(deptName));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+2);
      }
      return Left(Fail(message));
    }
  }

  @override
  Future<Either<Fail, List<Course>>> showAllCourses() async {
    try {
      return Right(await courseRemoteDataSource.allCourses());
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+2);
      }
      return Left(Fail(message));
    }
  }

  @override
  Future<Either<Fail, List<Course>>> showSemesterCourses(String deptName, String semester) async {
    try {
      return Right(await courseRemoteDataSource.semesterCourses(deptName, semester));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+2);
      }
      return Left(Fail(message));
    }
  }

}