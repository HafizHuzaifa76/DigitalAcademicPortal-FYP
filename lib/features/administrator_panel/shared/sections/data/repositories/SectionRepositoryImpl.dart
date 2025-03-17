
import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/teachers/domain/entities/Teacher.dart';
import '../../domain/entities/Section.dart';
import '../../domain/repositories/SectionRepository.dart';
import '../datasources/SectionRemoteDataSource.dart';
import '../models/SectionModel.dart';

class SectionRepositoryImpl implements SectionRepository{
  final SectionRemoteDataSource sectionRemoteDataSource;

  SectionRepositoryImpl({required this.sectionRemoteDataSource});

  @override
  Future<Either<Fail, Section>> addSection(String deptName, String semester, Section section) async {
    try {
      return Right(await sectionRemoteDataSource.addSection(deptName, semester, SectionModel.fromSection(section)));
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
  Future<Either<Fail, void>> deleteSection(String deptName, String semester, Section section) async {
    try {
      return Right(await sectionRemoteDataSource.deleteSection(deptName, semester, section.sectionID));
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
  Future<Either<Fail, Section>> editSection(String deptName, String semester, Section section) async {
    try {
      return Right(await sectionRemoteDataSource.editSection(deptName, semester, SectionModel.fromSection(section)));
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
  Future<Either<Fail, void>> assignTeacherToCourses(String deptName, String semester, String section, Map<String, dynamic> coursesTeachersMap) async {
    try {
      return Right(await sectionRemoteDataSource.assignTeacherToCourses(deptName, semester, section, coursesTeachersMap));
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
  Future<Either<Fail, Map<String, String?>>> fetchAssignedTeachers(String deptName, String semester, String section) async {
    try {
      return Right(await sectionRemoteDataSource.fetchAssignedTeachers(deptName, semester, section));
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
  Future<Either<Fail, void>> editAssignedTeachers(String deptName, String semester, String section, String courseName, Teacher teacher) async {
    try {
      return Right(await sectionRemoteDataSource.editAssignedTeacher(deptName, semester, section, courseName, teacher));
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
  Future<Either<Fail, List<Section>>> showAllSections(String deptName, String semester) async {
    try {
      return Right(await sectionRemoteDataSource.allSections(deptName, semester));
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