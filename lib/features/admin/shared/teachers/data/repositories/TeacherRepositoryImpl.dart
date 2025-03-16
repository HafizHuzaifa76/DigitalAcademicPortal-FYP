
import 'package:dartz/dartz.dart';
import '../../domain/entities/Teacher.dart';
import '../../domain/repositories/TeacherRepository.dart';
import '../datasources/TeacherRemoteDataSource.dart';
import '../models/TeacherModel.dart';

class TeacherRepositoryImpl implements TeacherRepository{
  final TeacherRemoteDataSource teacherRemoteDataSource;

  TeacherRepositoryImpl({required this.teacherRemoteDataSource});

  @override
  Future<Either<Fail, Teacher>> addTeacher(Teacher teacher) async {
    try {
      return Right(await teacherRemoteDataSource.addTeacher(TeacherModel.fromTeacher(teacher)));
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
  Future<Either<Fail, void>> deleteTeacher(Teacher teacher) async {
    try {
      return Right(await teacherRemoteDataSource.deleteTeacher(TeacherModel.fromTeacher(teacher)));
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
  Future<Either<Fail, Teacher>> editTeacher(Teacher teacher) async {
    try {
      return Right(await teacherRemoteDataSource.editTeacher(TeacherModel.fromTeacher(teacher)));
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
  Future<Either<Fail, List<Teacher>>> showAllTeachers() async {
    try {
      return Right(await teacherRemoteDataSource.allTeachers());
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
  Future<Either<Fail, List<Teacher>>> showDeptTeachers(String deptName) async {
    try {
      return Right(await teacherRemoteDataSource.getTeachersByDepartment(deptName));
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
  Future<Either<Fail, String>> addTeacherList(List<Teacher> teacherList) async {
    try {
      return Right(await teacherRemoteDataSource.addTeachersList(teacherList));
    } catch (e) {
    String message = e.toString();
    int startIndex = message.indexOf(']');
    if (startIndex != -1){
    message = message.substring(startIndex+1);
    }
    return Left(Fail(message));
    }
  }

}