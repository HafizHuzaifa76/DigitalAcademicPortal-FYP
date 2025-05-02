import 'package:digital_academic_portal/features/teacher_panel/shared/teacher_courses/domain/repositories/TeacherCourseRepository.dart';
import 'package:get/get.dart';
import '../../data/datasources/TeacherCourseRemoteDataSource.dart';
import '../../data/repositories/TeacherCourseRepositoryImpl.dart';
import '../../domain/usecases/FetchAllTeacherCoursesUseCase.dart';
import '../controllers/TeacherCourseController.dart';

class TeacherCourseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherCourseRemoteDataSource>(
      () => TeacherCourseRemoteDataSourceImpl(),
    );

    Get.lazyPut<TeacherCourseRepository>(
      () => TeacherCourseRepositoryImpl(Get.find()),
    );

    Get.lazyPut(() => FetchAllTeacherCoursesUseCase(Get.find()));

    Get.lazyPut<TeacherCourseController>(
      () => TeacherCourseController(fetchAllTeacherCourses: Get.find()),
    );
  }
}
