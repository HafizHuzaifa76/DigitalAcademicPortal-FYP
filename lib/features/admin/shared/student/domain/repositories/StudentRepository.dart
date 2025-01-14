
import 'package:dartz/dartz.dart';
import '../entities/Student.dart';

abstract class StudentRepository{

  Future<Either<Fail, Student>> addStudent(Student student);
  Future<Either<Fail, void>> addStudentList(List<Student> morningStudents, List<Student> eveningStudents);
  Future<Either<Fail, Student>> editStudent(Student student);
  Future<Either<Fail, void>> deleteStudent(Student student);
  Future<Either<Fail, List<Student>>> showAllStudents();
  Future<Either<Fail, List<Student>>> showDepartmentStudents(String deptName);
  Future<Either<Fail, List<Student>>> showSemesterStudents(String deptName, String semester);
  Future<Either<Fail, void>> setSectionLimit(String deptName, String semester, int limit);

}