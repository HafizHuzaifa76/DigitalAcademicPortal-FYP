import 'package:digital_academic_portal/features/administrator_panel/shared/departments/domain/usecases/AllSemestersUseCase.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/departments/domain/usecases/UpdateSemesterCoursesUseCase.dart';
import 'package:get/get.dart';

import '../../data/datasources/DepartmentRemoteDataSource.dart';
import '../../data/repositories/DepartmentRepositoryImpl.dart';
import '../../domain/repositories/DepartmentRepository.dart';
import '../../domain/usecases/AddDepartmentUseCase.dart';
import '../../domain/usecases/AllDepartmentsUseCase.dart';
import '../../domain/usecases/DeleteDepartmentUseCase.dart';
import '../../domain/usecases/EditDepartmentUseCase.dart';
import '../controllers/DepartmentController.dart';

class DepartmentBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<DepartmentRemoteDataSource>(() => DepartmentRemoteDataSourceImpl());
    Get.lazyPut<DepartmentRepository>(() => DepartmentRepositoryImpl(departmentRemoteDataSource: Get.find()));
    Get.lazyPut(() => AllDepartmentsUseCase(Get.find()));
    Get.lazyPut(() => AddDepartmentUseCase(Get.find()));
    Get.lazyPut(() => EditDepartmentUseCase(Get.find()));
    Get.lazyPut(() => DeleteDepartmentUseCase(Get.find()));
    Get.lazyPut(() => AllSemestersUseCase(Get.find()));
    Get.lazyPut(() => DepartmentController(addDepartmentUseCase: Get.find(), deleteDepartmentUseCase: Get.find(), editDepartmentUseCase: Get.find(), allDepartmentsUseCase: Get.find(), allSemestersUseCase: Get.find()));
  }

}