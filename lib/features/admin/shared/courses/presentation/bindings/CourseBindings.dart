
import 'package:digital_academic_portal/features/admin/shared/courses/domain/usecases/DeptCoursesUseCase.dart';
import 'package:digital_academic_portal/features/admin/shared/courses/domain/usecases/SemesterCoursesUseCase.dart';
import 'package:get/get.dart';

import '../../../departments/data/datasources/DepartmentRemoteDataSource.dart';
import '../../../departments/data/repositories/DepartmentRepositoryImpl.dart';
import '../../../departments/domain/repositories/DepartmentRepository.dart';
import '../../../departments/domain/usecases/UpdateSemesterCoursesUseCase.dart';
import '../../data/datasources/CourseRemoteDataSource.dart';
import '../../data/repositories/CourseRepositoryImpl.dart';
import '../../domain/repositories/CourseRepository.dart';
import '../../domain/usecases/AddCourseUseCase.dart';
import '../../domain/usecases/AllCourseUseCase.dart';
import '../../domain/usecases/DeleteCourseUseCase.dart';
import '../../domain/usecases/EditCourseUseCase.dart';
import '../../domain/usecases/UpdateCourseInSemesterUseCase.dart';
import '../controllers/CourseController.dart';

class CourseBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<CourseRemoteDataSource>(() => CourseRemoteDataSourceImpl());
    Get.lazyPut<CourseRepository>(() => CourseRepositoryImpl(courseRemoteDataSource: Get.find()));
    Get.lazyPut<DepartmentRepository>(() => DepartmentRepositoryImpl(departmentRemoteDataSource: Get.find()));
    Get.lazyPut<DepartmentRemoteDataSource>(() => DepartmentRemoteDataSourceImpl());
    Get.lazyPut(() => AllCoursesUseCase(Get.find()));
    Get.lazyPut(() => AddCourseUseCase(Get.find()));
    Get.lazyPut(() => EditCourseUseCase(Get.find()));
    Get.lazyPut(() => DeleteCourseUseCase(Get.find()));
    Get.lazyPut(() => DeptCoursesUseCase(Get.find()));
    Get.lazyPut(() => SemesterCoursesUseCase(Get.find()));
    Get.lazyPut(() => UpdateCourseInSemesterUseCase(Get.find()));
    Get.lazyPut(() => UpdateSemesterCourseUseCase());
    Get.lazyPut(() => CourseController(addCourseUseCase: Get.find(), deleteCourseUseCase: Get.find(), editCourseUseCase: Get.find(), allCoursesUseCase: Get.find(), deptCoursesUseCase: Get.find(), semesterCoursesUseCase: Get.find(), updateCourseInSemesterUseCase: Get.find()));
  }
}