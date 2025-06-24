import 'package:get/get.dart';

import '../../../teacher_courses/data/datasources/TeacherCourseRemoteDataSource.dart';
import '../../../teacher_courses/data/repositories/TeacherCourseRepositoryImpl.dart';
import '../../../teacher_courses/domain/repositories/TeacherCourseRepository.dart';
import '../../../teacher_courses/domain/usecases/FetchAllTeacherCoursesUseCase.dart';
import '../../domain/usecases/GetTeacherCoursesUseCase.dart';

import '../../domain/usecases/CreateAssignmentUseCase.dart';
import '../../domain/usecases/GetAssignmentsUseCase.dart';
import '../../data/datasources/TeacherAssignmentRemoteDataSource.dart';
import '../../data/repositories/TeacherAssignmentRepositoryImpl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controllers/TeacherAssignmentController.dart';

class TeacherAssignmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FirebaseFirestore.instance);

    // Course dependencies
    Get.lazyPut<TeacherCourseRemoteDataSource>(
      () => TeacherCourseRemoteDataSourceImpl(),
    );

    Get.lazyPut<TeacherCourseRepository>(
      () => TeacherCourseRepositoryImpl(Get.find()),
    );

    Get.lazyPut(() => FetchAllTeacherCoursesUseCase(Get.find()));
    Get.lazyPut(() => GetTeacherCoursesUseCase(Get.find()));

    Get.lazyPut<TeacherAssignmentRemoteDataSource>(
        () => TeacherAssignmentRemoteDataSourceImpl());

    Get.lazyPut<TeacherAssignmentRepositoryImpl>(
        () => TeacherAssignmentRepositoryImpl(remoteDataSource: Get.find()));

    Get.lazyPut(() =>
        GetAssignmentsUseCase(Get.find<TeacherAssignmentRepositoryImpl>()));
    Get.lazyPut(() =>
        CreateAssignmentUseCase(Get.find<TeacherAssignmentRepositoryImpl>()));

    Get.lazyPut(() => TeacherAssignmentController(
          getAssignmentsUseCase: Get.find(),
          createAssignmentUseCase: Get.find(),
          getTeacherCoursesUseCase: Get.find(),
        ));
  }
}
