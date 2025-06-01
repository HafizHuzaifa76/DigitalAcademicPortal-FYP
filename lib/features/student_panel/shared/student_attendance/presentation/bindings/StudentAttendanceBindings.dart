import 'package:get/get.dart';
import '../../../student_courses/data/datasources/StudentCoursesRemoteDataSource.dart';
import '../../../student_courses/data/repositories/StudentCoursesRepositoryImpl.dart';
import '../../../student_courses/domain/repositories/StudentCoursesRepository.dart';
import '../../../student_courses/domain/usecases/FetchStudentCoursesUseCase.dart';
import '../../data/data_sources/StudentAttendanceRemoteDataSource.dart';
import '../../data/repositories/StudentAttendanceRepositoryImpl.dart';
import '../../domain/repositories/StudentAttendanceRepository.dart';
import '../../domain/use_cases/GetStudentAttendanceUseCase.dart';
import '../../domain/use_cases/GetStudentCourses.dart';
import '../manager/StudentAttendanceController.dart';

class StudentAttendanceBinding extends Bindings {
  @override
  void dependencies() {
    
    Get.lazyPut<StudentCoursesRemoteDataSource>(
      () => StudentCoursesRemoteDataSourceImpl(),
    );

    Get.lazyPut<StudentCoursesRepository>(
      () => StudentCoursesRepositoryImpl(Get.find()),
    );

    Get.lazyPut<StudentAttendanceRemoteDataSource>(
      () => StudentAttendanceRemoteDataSourceImpl(),
    );
    
    Get.lazyPut<StudentAttendanceRepository>(
      () => StudentAttendanceRepositoryImpl(
        remoteDataSource: Get.find(),
      ),
    );

    Get.lazyPut(() => FetchStudentCoursesUseCase(Get.find()));
    Get.lazyPut(() => GetStudentAttendanceUseCase(Get.find()));
    Get.lazyPut(() => GetStudentCourses(Get.find()));
    Get.lazyPut(() => StudentAttendanceController(
          getStudentAttendanceUseCase: Get.find(),
          getStudentCoursesUseCase: Get.find(),
        ));
  }
}