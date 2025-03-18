import 'package:dartz/dartz.dart';
import '../entities/Department.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../repositories/DepartmentRepository.dart';

class AllDepartmentsUseCase implements UseCase<List<Department>, void>{
  final DepartmentRepository repository;

  AllDepartmentsUseCase(this.repository);

  @override
  Future<Either<Fail, List<Department>>> execute(void params) async {
    return await repository.showAllDepartments();
  }
}