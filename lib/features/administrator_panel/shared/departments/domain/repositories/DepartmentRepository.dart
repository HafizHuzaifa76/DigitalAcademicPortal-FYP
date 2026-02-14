
import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/departments/data/models/SemesterModel.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/departments/domain/entities/Semester.dart';
import '../entities/Department.dart';

abstract class DepartmentRepository{

  Future<Either<Fail, Department>> addDepartment(Department department);
  Future<Either<Fail, Department>> editDepartment(Department department);
  Future<Either<Fail, void>> deleteDepartment(Department department);
  Future<Either<Fail, List<Department>>> showAllDepartments();
  Future<Either<Fail, List<Semester>>> showAllSemesters(String deptName);
  Future<Either<Fail, SemesterModel>> updateSemesterData(String deptName, Semester semester);

}