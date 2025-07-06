import 'package:digital_academic_portal/features/teacher_panel/shared/teacher_courses/domain/repositories/TeacherCourseRepository.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/datasources/TeacherCourseRemoteDataSource.dart';
import '../../data/repositories/TeacherCourseRepositoryImpl.dart';
import '../../domain/usecases/FetchAllTeacherCoursesUseCase.dart';
import '../../domain/usecases/GetStudentNamesUseCase.dart';
import '../../domain/usecases/GetQueriesUseCase.dart';
import '../../domain/usecases/RespondToQueryUseCase.dart';
import '../controllers/TeacherCourseController.dart';

// UploadedFile dependencies
import '../../data/datasources/UploadedFileRemoteDataSource.dart';
import '../../data/repositories/UploadedFileRepositoryImpl.dart';
import '../../domain/repositories/UploadedFileRepository.dart';
import '../../domain/usecases/GetUploadedFilesUseCase.dart';
import '../../domain/usecases/UploadFileUseCase.dart';
import '../../domain/usecases/DeleteFileUseCase.dart';
import '../controllers/UploadedFileController.dart';

class TeacherCourseBinding extends Bindings {
  @override
  void dependencies() {
    // TeacherCourse dependencies
    Get.lazyPut<TeacherCourseRemoteDataSource>(
      () => TeacherCourseRemoteDataSourceImpl(),
    );

    Get.lazyPut<TeacherCourseRepository>(
      () => TeacherCourseRepositoryImpl(Get.find()),
    );

    Get.lazyPut(() => FetchAllTeacherCoursesUseCase(Get.find()));
    Get.lazyPut(() => GetStudentNamesUseCase(Get.find()));
    Get.lazyPut(() => GetQueriesUseCase(Get.find()));
    Get.lazyPut(() => RespondToQueryUseCase(Get.find()));

    Get.lazyPut<TeacherCourseController>(
      () => TeacherCourseController(
        fetchAllTeacherCourses: Get.find(),
        getStudentNamesUseCase: Get.find(),
        getQueriesUseCase: Get.find(),
        respondToQueryUseCase: Get.find(),
      ),
    );

    // UploadedFile dependencies - Add these to ensure UploadedFileController is available
    Get.lazyPut(() => FirebaseFirestore.instance);

    Get.lazyPut<UploadedFileRemoteDataSource>(
      () => UploadedFileRemoteDataSourceImpl(),
    );

    Get.lazyPut<UploadedFileRepository>(
      () => UploadedFileRepositoryImpl(remoteDataSource: Get.find()),
    );

    Get.lazyPut(() => GetUploadedFilesUseCase(Get.find()));
    Get.lazyPut(() => UploadFileUseCase(Get.find()));
    Get.lazyPut(() => DeleteFileUseCase(Get.find()));

    // Use Get.put() for UploadedFileController to ensure persistence
    Get.put<UploadedFileController>(
      UploadedFileController(
        getFilesUseCase: Get.find(),
        uploadFileUseCase: Get.find(),
        deleteFileUseCase: Get.find(),
      ),
      permanent: true,
    );
  }
}
