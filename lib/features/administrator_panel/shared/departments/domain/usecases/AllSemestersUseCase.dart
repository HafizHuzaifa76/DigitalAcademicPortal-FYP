import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/departments/domain/entities/Semester.dart';
import '../entities/Department.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../repositories/DepartmentRepository.dart';

class AllSemestersUseCase implements UseCase<List<Semester>, String>{
  final DepartmentRepository repository;

  AllSemestersUseCase(this.repository);

  @override
  Future<Either<Fail, List<Semester>>> execute(String deptName) async {
    return await repository.showAllSemesters(deptName);
  }
}