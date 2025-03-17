
import 'package:dartz/dartz.dart';
import '../entities/Teacher.dart';

abstract class TeacherRepository{

  Future<Either<Fail, Teacher>> addTeacher(Teacher teacher);
  Future<Either<Fail, String>> addTeacherList(List<Teacher> teacherList);
  Future<Either<Fail, Teacher>> editTeacher(Teacher teacher);
  Future<Either<Fail, void>> deleteTeacher(Teacher teacher);
  Future<Either<Fail, List<Teacher>>> showAllTeachers();
  Future<Either<Fail, List<Teacher>>> showDeptTeachers(String deptName);

}