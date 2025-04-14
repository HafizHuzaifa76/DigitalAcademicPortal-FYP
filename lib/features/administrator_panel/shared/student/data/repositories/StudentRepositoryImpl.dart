
import 'package:dartz/dartz.dart';
import '../../domain/entities/Student.dart';
import '../../domain/repositories/StudentRepository.dart';
import '../datasources/StudentRemoteDataSource.dart';
import '../models/StudentModel.dart';

class StudentRepositoryImpl implements StudentRepository{
  final StudentRemoteDataSource studentRemoteDataSource;

  StudentRepositoryImpl({required this.studentRemoteDataSource});

  @override
  Future<Either<Fail, Student>> addStudent(Student student) async {
    try {
      return Right(await studentRemoteDataSource.addStudent(StudentModel.fromStudent(student)));
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
  Future<Either<Fail, void>> addStudentList(List<Student> morningStudents, List<Student> eveningStudents, bool newStudents) async {
    try {
      return Right(
         newStudents ? await studentRemoteDataSource.addNewStudentsList(morningStudents, eveningStudents)
             : await studentRemoteDataSource.addPreviousStudentsList(morningStudents, eveningStudents)
      );
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
  Future<Either<Fail, void>> deleteStudent(Student student) async {
    try {
      return Right(await studentRemoteDataSource.deleteStudent(student.studentDepartment, student.studentRollNo));
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
  Future<Either<Fail, Student>> editStudent(Student student) async {
    try {
      return Right(await studentRemoteDataSource.editStudent(StudentModel.fromStudent(student)));
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
  Future<Either<Fail, Map<String, List<StudentModel>>>> showAllStudents() async {
    try {
      return Right(await studentRemoteDataSource.allStudents());
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
  Future<Either<Fail, List<Student>>> showDepartmentStudents(String deptName) async {
    try {
      return Right(await studentRemoteDataSource.getStudentsByDepartment(deptName));
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
  Future<Either<Fail, List<Student>>> showSemesterStudents(String deptName, String semester) async {
    try {
      return Right(await studentRemoteDataSource.getStudentsBySemester(deptName, semester));
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
  Future<Either<Fail, void>> setSectionLimit(String deptName, String semester, int limit) async {
    try {
      return Right(await studentRemoteDataSource.setSectionLimit(deptName, semester, limit));
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