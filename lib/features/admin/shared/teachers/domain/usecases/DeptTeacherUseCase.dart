import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/Teacher.dart';
import '../repositories/TeacherRepository.dart';

class DeptTeachersUseCase implements UseCase<List<Teacher>, String>{
  final TeacherRepository repository;

  DeptTeachersUseCase(this.repository);

  @override
  Future<Either<Fail, List<Teacher>>> execute(String deptName) async {
    return await repository.showDeptTeachers(deptName);
  }
}