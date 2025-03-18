import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/Student.dart';
import '../repositories/StudentRepository.dart';

class DepartmentStudentsUseCase implements UseCase<List<Student>, String>{
  final StudentRepository repository;

  DepartmentStudentsUseCase(this.repository);

  @override
  Future<Either<Fail, List<Student>>> execute(String deptName) async {
    return await repository.showDepartmentStudents(deptName);
  }
}