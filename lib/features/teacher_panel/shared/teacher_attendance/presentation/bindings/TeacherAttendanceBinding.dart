import 'package:get/get.dart';
import '../../../teacher_courses/data/datasources/TeacherCourseRemoteDataSource.dart';
import '../../../teacher_courses/data/repositories/TeacherCourseRepositoryImpl.dart';
import '../../../teacher_courses/domain/repositories/TeacherCourseRepository.dart';
import '../../../teacher_courses/domain/usecases/FetchAllTeacherCoursesUseCase.dart';
import '../../../teacher_timetable/data/datasources/TeacherTimeTableRemoteDataSource.dart';
import '../../../teacher_timetable/data/repositories/TeacherTimeTableRepositoryImpl.dart';
import '../../../teacher_timetable/domain/repositories/TeacherTimeTableRepository.dart';
import '../../../teacher_timetable/domain/usecases/FetchTeacherTimetable.dart';
import '../../domain/usecases/GetTeacherCoursesUseCase.dart';
import '../../data/datasources/TeacherAttendanceRemoteDataSource.dart';
import '../../data/repositories/TeacherAttendanceRepositoryImpl.dart';
import '../../domain/repositories/TeacherAttendanceRepository.dart';
import '../../domain/usecases/GetCourseAttendanceUseCase.dart';
import '../../domain/usecases/MarkAttendanceUseCase.dart';
import '../controllers/TeacherAttendanceController.dart';

class TeacherAttendanceBinding extends Bindings {
  @override
  void dependencies() {
    // timetable dependencies
    Get.lazyPut<TeacherTimeTableRemoteDataSource>(
      () => TeacherTimeTableRemoteDataSourceImpl(),
    );

    Get.lazyPut<TeacherTimeTableRepository>(
      () => TeacherTimeTableRepositoryImpl(Get.find()),
    );

    Get.lazyPut(() => FetchTeacherTimetable(Get.find()));

    // Course dependencies
    Get.lazyPut<TeacherCourseRemoteDataSource>(
      () => TeacherCourseRemoteDataSourceImpl(),
    );

    Get.lazyPut<TeacherCourseRepository>(
      () => TeacherCourseRepositoryImpl(Get.find()),
    );

    Get.lazyPut(() => FetchAllTeacherCoursesUseCase(Get.find()));
    Get.lazyPut(() => GetTeacherCoursesUseCase(Get.find()));

    // Attendance dependencies
    Get.lazyPut<TeacherAttendanceRemoteDataSource>(
      () => TeacherAttendanceRemoteDataSourceImpl(),
    );

    Get.lazyPut<TeacherAttendanceRepository>(
      () => TeacherAttendanceRepositoryImpl(Get.find()),
    );

    Get.lazyPut(() => GetCourseAttendanceUseCase(Get.find()));
    Get.lazyPut(() => MarkAttendanceUseCase(Get.find()));

    // Controller
    Get.lazyPut(() => TeacherAttendanceController(
          getTeacherCoursesUseCase: Get.find(),
          getCourseAttendanceUseCase: Get.find(),
          markAttendanceUseCase: Get.find(),
          fetchTeacherTimetable: Get.find(),
        ));
  }
}
