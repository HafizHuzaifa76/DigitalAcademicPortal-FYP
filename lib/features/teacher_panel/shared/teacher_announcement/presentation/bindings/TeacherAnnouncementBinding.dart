import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Teacher Courses dependencies
import '../../../teacher_courses/data/datasources/TeacherCourseRemoteDataSource.dart';
import '../../../teacher_courses/data/repositories/TeacherCourseRepositoryImpl.dart';
import '../../../teacher_courses/domain/repositories/TeacherCourseRepository.dart';
import '../../../teacher_courses/domain/usecases/FetchAllTeacherCoursesUseCase.dart';

// Announcement dependencies
import '../../domain/usecases/GetAnnouncementsUseCase.dart';
import '../../domain/usecases/CreateAnnouncementUseCase.dart';
import '../../domain/usecases/UpdateAnnouncementUseCase.dart';
import '../../domain/usecases/DeleteAnnouncementUseCase.dart';
import '../../data/datasources/AnnouncementRemoteDataSource.dart';
import '../../data/repositories/AnnouncementRepositoryImpl.dart';
import '../../domain/repositories/AnnouncementRepository.dart';
import '../controllers/TeacherAnnouncementController.dart';

class TeacherAnnouncementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FirebaseFirestore.instance);

    // Teacher Courses dependencies
    Get.lazyPut<TeacherCourseRemoteDataSource>(
      () => TeacherCourseRemoteDataSourceImpl(),
    );
    Get.lazyPut<TeacherCourseRepository>(
      () => TeacherCourseRepositoryImpl(Get.find()),
    );
    Get.lazyPut(() => FetchAllTeacherCoursesUseCase(Get.find()));

    // Announcement dependencies
    Get.lazyPut<AnnouncementRemoteDataSource>(
      () => AnnouncementRemoteDataSourceImpl(),
    );
    Get.lazyPut<AnnouncementRepository>(
      () => AnnouncementRepositoryImpl(remoteDataSource: Get.find()),
    );
    Get.lazyPut(() => GetAnnouncementsUseCase(Get.find()));
    Get.lazyPut(() => CreateAnnouncementUseCase(Get.find()));
    Get.lazyPut(() => UpdateAnnouncementUseCase(Get.find()));
    Get.lazyPut(() => DeleteAnnouncementUseCase(Get.find()));

    // Controller
    Get.lazyPut(() => TeacherAnnouncementController(
          getAnnouncementsUseCase: Get.find(),
          createAnnouncementUseCase: Get.find(),
          updateAnnouncementUseCase: Get.find(),
          deleteAnnouncementUseCase: Get.find(),
          fetchAllTeacherCoursesUseCase: Get.find(),
    ));
  }
}
