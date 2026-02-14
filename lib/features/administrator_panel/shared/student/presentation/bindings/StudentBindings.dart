
import 'package:digital_academic_portal/features/administrator_panel/shared/student/domain/usecases/AddStudentListUseCase.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/student/domain/usecases/DepartmentStudentsUseCase.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/student/domain/usecases/SemesterStudentsUseCase.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/student/domain/usecases/SetSectionLimitUseCase.dart';
import 'package:get/get.dart';

import '../../data/datasources/StudentRemoteDataSource.dart';
import '../../data/repositories/StudentRepositoryImpl.dart';
import '../../domain/repositories/StudentRepository.dart';
import '../../domain/usecases/AddStudentUseCase.dart';
import '../../domain/usecases/AllStudentUseCase.dart';
import '../../domain/usecases/DeleteStudentUseCase.dart';
import '../../domain/usecases/EditStudentUseCase.dart';
import '../controllers/StudentController.dart';

class StudentBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut<StudentRemoteDataSource>(() => StudentRemoteDataSourceImpl());
    Get.lazyPut<StudentRepository>(() => StudentRepositoryImpl(studentRemoteDataSource: Get.find()));
    Get.lazyPut(() => AllStudentsUseCase(Get.find()));
    Get.lazyPut(() => AddStudentUseCase(Get.find()));
    Get.lazyPut(() => AddStudentListUseCase(Get.find()));
    Get.lazyPut(() => EditStudentUseCase(Get.find()));
    Get.lazyPut(() => DeleteStudentUseCase(Get.find()));
    Get.lazyPut(() => DepartmentStudentsUseCase(Get.find()));
    Get.lazyPut(() => DepartmentStudentsUseCase(Get.find()));
    Get.lazyPut(() => SemesterStudentsUseCase(Get.find()));
    Get.lazyPut(() => SetSectionLimitUseCase(Get.find()));
    Get.lazyPut(() => StudentController(addStudentUseCase: Get.find(), addStudentListUseCase: Get.find(), deleteStudentUseCase: Get.find(), editStudentUseCase: Get.find(), allStudentsUseCase: Get.find(), departmentStudentsUseCase: Get.find(), semesterStudentsUseCase: Get.find(), setSectionLimitUseCase: Get.find()));
  }

}