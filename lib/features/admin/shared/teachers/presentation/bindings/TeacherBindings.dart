
import 'package:digital_academic_portal/features/admin/shared/teachers/domain/usecases/DeptTeacherUseCase.dart';
import 'package:get/get.dart';

import '../../data/datasources/TeacherRemoteDataSource.dart';
import '../../data/repositories/TeacherRepositoryImpl.dart';
import '../../domain/repositories/TeacherRepository.dart';
import '../../domain/usecases/AddTeacherUseCase.dart';
import '../../domain/usecases/AllTeacherUseCase.dart';
import '../../domain/usecases/DeleteTeacherUseCase.dart';
import '../../domain/usecases/EditTeacherUseCase.dart';
import '../controllers/TeacherController.dart';

class TeacherBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<TeacherRemoteDataSource>(() => TeacherRemoteDataSourceImpl());
    Get.lazyPut<TeacherRepository>(() => TeacherRepositoryImpl(teacherRemoteDataSource: Get.find()));
    Get.lazyPut(() => AllTeachersUseCase(Get.find()));
    Get.lazyPut(() => AddTeacherUseCase(Get.find()));
    Get.lazyPut(() => EditTeacherUseCase(Get.find()));
    Get.lazyPut(() => DeleteTeacherUseCase(Get.find()));
    Get.lazyPut(() => DeptTeachersUseCase(Get.find()));
    Get.lazyPut(() => TeacherController(addTeacherUseCase: Get.find(), deleteTeacherUseCase: Get.find(), editTeacherUseCase: Get.find(), allTeachersUseCase: Get.find(), deptTeachersUseCase: Get.find()));
  }
}