
import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/features/admin/shared/courses/data/models/DeptCourseModel.dart';
import 'package:digital_academic_portal/features/admin/shared/courses/domain/entities/DepartmentCourse.dart';
import '../../domain/entities/SemesterCourse.dart';
import '../../domain/repositories/CourseRepository.dart';
import '../datasources/CourseRemoteDataSource.dart';
import '../models/SemesterCourseModel.dart';

class CourseRepositoryImpl implements CourseRepository{
  final CourseRemoteDataSource courseRemoteDataSource;

  CourseRepositoryImpl({required this.courseRemoteDataSource});

  @override
  Future<Either<Fail, DepartmentCourse>> addCourse(String deptName, DepartmentCourse course) async {
    try {
      return Right(await courseRemoteDataSource.addCourse(deptName, DeptCourseModel.fromCourse(course)));
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
  Future<Either<Fail, void>> addCourseList(List<DepartmentCourse> courses) async {
    try {
      return Right(await courseRemoteDataSource.addCoursesList(courses.first.courseDept, courses));
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
  Future<Either<Fail, void>> deleteCourse(String deptName, DepartmentCourse course) async {
    try {
      return Right(await courseRemoteDataSource.deleteCourse(deptName, DeptCourseModel.fromCourse(course)));
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
  Future<Either<Fail, DepartmentCourse>> editCourse(String deptName, DepartmentCourse course) async {
    try {
      return Right(await courseRemoteDataSource.editCourse(deptName, DeptCourseModel.fromCourse(course)));
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
  Future<Either<Fail, List<DepartmentCourse>>> showDeptCourses(String deptName) async {
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
  Future<Either<Fail, List<SemesterCourse>>> showAllCourses() async {
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
  Future<Either<Fail, List<SemesterCourse>>> showSemesterCourses(String deptName, String semester) async {
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