import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/features/admin/shared/departments/data/models/SemesterModel.dart';
import 'package:digital_academic_portal/features/admin/shared/departments/domain/entities/Semester.dart';
import 'package:get/get.dart';
import '../entities/Department.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../repositories/DepartmentRepository.dart';

class UpdateSemesterCourseUseCase implements UseCase<SemesterModel, UpdateSemesterParams>{
  final DepartmentRepository repository = Get.find();

  UpdateSemesterCourseUseCase();

  @override
  Future<Either<Fail, SemesterModel>> execute(UpdateSemesterParams updateSemesterParams) async {
    return await repository.updateSemesterData(updateSemesterParams.deptName, updateSemesterParams.semester);
  }
}