
import 'package:dartz/dartz.dart';
import '../entities/Student.dart';

abstract class StudentRepository{

  Future<Either<Fail, Student>> addStudent(Student student);
  Future<Either<Fail, Student>> editStudent(Student student);
  Future<Either<Fail, void>> deleteStudent(Student student);
  Future<Either<Fail, List<Student>>> showAllStudents();

}