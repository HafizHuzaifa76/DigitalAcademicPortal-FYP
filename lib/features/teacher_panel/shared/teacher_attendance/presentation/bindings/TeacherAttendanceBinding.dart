import 'package:digital_academic_portal/features/teacher_panel/shared/teacher_attendance/domain/usecases/GetTeacherCoursesUseCase.dart';
import 'package:digital_academic_portal/features/teacher_panel/shared/teacher_courses/data/repositories/TeacherCourseRepositoryImpl.dart';
import 'package:digital_academic_portal/features/teacher_panel/shared/teacher_courses/domain/repositories/TeacherCourseRepository.dart';
import 'package:get/get.dart';
import '../../../teacher_courses/data/datasources/TeacherCourseRemoteDataSource.dart';
import '../../../teacher_courses/domain/usecases/FetchAllTeacherCoursesUseCase.dart';
import '../../data/datasources/TeacherAttendanceRemoteDataSource.dart';
import '../../data/repositories/TeacherAttendanceRepositoryImpl.dart';
import '../../domain/repositories/TeacherAttendanceRepository.dart';
import '../../domain/usecases/GetTeacherAttendanceUseCase.dart';
import '../controllers/TeacherAttendanceController.dart';

class TeacherAttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherAttendanceRemoteDataSource>(
      () => TeacherAttendanceRemoteDataSourceImpl(),
    );

    Get.lazyPut<TeacherAttendanceRepository>(
      () => TeacherAttendanceRepositoryImpl(Get.find()),
    );

    Get.lazyPut<TeacherCourseRemoteDataSource>(
      () => TeacherCourseRemoteDataSourceImpl(),
    );

    Get.lazyPut<TeacherCourseRepository>(
      () => TeacherCourseRepositoryImpl(Get.find()),
    );
    Get.lazyPut(() => GetTeacherAttendanceUseCase(Get.find()));
    Get.lazyPut(() => FetchAllTeacherCoursesUseCase(Get.find()));
    Get.lazyPut(() => GetTeacherCoursesUseCase(Get.find()));

    Get.lazyPut(() => TeacherAttendanceController(getTeacherAttendanceUseCase: Get.find(), getTeacherCoursesUseCase: Get.find()));
  }
}
