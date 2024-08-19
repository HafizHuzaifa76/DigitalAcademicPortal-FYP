import 'package:dartz/dartz.dart';
import '../entities/Department.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../repositories/DepartmentRepository.dart';

class DeleteDepartmentUseCase implements UseCase<void, Department>{
  final DepartmentRepository repository;

  DeleteDepartmentUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(Department department) async {
    return await repository.deleteDepartment(department);
  }
}