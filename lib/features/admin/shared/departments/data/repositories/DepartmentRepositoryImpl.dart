
import 'package:dartz/dartz.dart';
import '../../domain/entities/Department.dart';
import '../datasources/DepartmentRemoteDataSource.dart';
import '../models/DepartmentModel.dart';


import '../../domain/repositories/DepartmentRepository.dart';

class DepartmentRepositoryImpl implements DepartmentRepository{
  final DepartmentRemoteDataSource departmentRemoteDataSource;

  DepartmentRepositoryImpl({required this.departmentRemoteDataSource});

  @override
  Future<Either<Fail, Department>> addDepartment(Department department) async {
    try {
      return Right(await departmentRemoteDataSource.addDepartment(DepartmentModel.fromDepartment(department)));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+1);
      }
      return Left(Fail(message));
    }
  }

  @override
  Future<Either<Fail, void>> deleteDepartment(Department department) async {
    try {
      return Right(await departmentRemoteDataSource.deleteDepartment(department.departmentName));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+1);
      }
      return Left(Fail(message));
    }
  }

  @override
  Future<Either<Fail, Department>> editDepartment(Department department) async {
    try {
      return Right(await departmentRemoteDataSource.editDepartment(DepartmentModel.fromDepartment(department)));
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+2);
      }
      return Left(Fail(message));
    }
  }

  @override
  Future<Either<Fail, List<Department>>> showAllDepartments() async {
    try {
      return Right(await departmentRemoteDataSource.allDepartments());
    } catch (e) {
      String message = e.toString();
      int startIndex = message.indexOf(']');
      if (startIndex != -1){
        message = message.substring(startIndex+2);
      }
      return Left(Fail(message));
    }
  }

}