
import 'package:dartz/dartz.dart';
import '../entities/Teacher.dart';

abstract class TeacherRepository{

  Future<Either<Fail, Teacher>> addTeacher(Teacher Teacher);
  Future<Either<Fail, Teacher>> editTeacher(Teacher Teacher);
  Future<Either<Fail, void>> deleteTeacher(Teacher Teacher);
  Future<Either<Fail, List<Teacher>>> showAllTeachers();

}