
import 'package:dartz/dartz.dart';
import '../entities/Department.dart';

abstract class DepartmentRepository{

  Future<Either<Fail, Department>> addDepartment(Department department);
  Future<Either<Fail, Department>> editDepartment(Department department);
  Future<Either<Fail, void>> deleteDepartment(Department department);
  Future<Either<Fail, List<Department>>> showAllDepartments();

}