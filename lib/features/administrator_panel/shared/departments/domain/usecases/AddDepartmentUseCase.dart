import 'package:dartz/dartz.dart';
import '../entities/Department.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../repositories/DepartmentRepository.dart';

class AddDepartmentUseCase implements UseCase<Department, Department>{
  final DepartmentRepository repository;

  AddDepartmentUseCase(this.repository);

  @override
  Future<Either<Fail, Department>> execute(Department department) async {
    return await repository.addDepartment(department);
  }
}