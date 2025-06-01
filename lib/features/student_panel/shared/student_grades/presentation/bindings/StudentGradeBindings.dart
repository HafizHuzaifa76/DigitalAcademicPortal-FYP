import 'package:get/get.dart';
import '../../../student_courses/data/datasources/StudentCoursesRemoteDataSource.dart';
import '../../../student_courses/data/repositories/StudentCoursesRepositoryImpl.dart';
import '../../../student_courses/domain/repositories/StudentCoursesRepository.dart';
import '../../../student_courses/domain/usecases/FetchStudentCoursesUseCase.dart';
import '../../data/data_sources/StudentGradeRemoteDataSource.dart';
import '../../data/data_sources/PreviousCourseGradeRemoteDataSource.dart';
import '../../data/repositories/StudentGradeRepositoryImpl.dart';
import '../../data/repositories/PreviousCourseGradeRepositoryImpl.dart';
import '../../domain/repositories/StudentGradeRepository.dart';
import '../../domain/repositories/PreviousCourseGradeRepository.dart';
import '../../domain/use_cases/GetStudentGradesUseCase.dart';
import '../../domain/use_cases/GetAllGradesUseCase.dart';
import '../../domain/use_cases/GetStudentCourses.dart';
import '../../domain/use_cases/GetPreviousCourseGradesUseCase.dart';
import '../../domain/use_cases/GetPreviousSemesterGradesUseCase.dart';
import '../manager/StudentGradeController.dart';

class StudentGradeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentCoursesRemoteDataSource>(
      () => StudentCoursesRemoteDataSourceImpl(),
    );

    Get.lazyPut<StudentCoursesRepository>(
      () => StudentCoursesRepositoryImpl(Get.find()),
    );

    Get.lazyPut<StudentGradeRemoteDataSource>(
      () => StudentGradeRemoteDataSourceImpl(),
    );

    Get.lazyPut<PreviousCourseGradeRemoteDataSource>(
      () => PreviousCourseGradeRemoteDataSourceImpl(),
    );

    Get.lazyPut<StudentGradeRepository>(
      () => StudentGradeRepositoryImpl(
        remoteDataSource: Get.find(),
      ),
    );

    Get.lazyPut<PreviousCourseGradeRepository>(
      () => PreviousCourseGradeRepositoryImpl(
        remoteDataSource: Get.find(),
      ),
    );

    Get.lazyPut(() => FetchStudentCoursesUseCase(Get.find()));
    Get.lazyPut(() => GetStudentGradesUseCase(Get.find()));
    Get.lazyPut(() => GetAllGradesUseCase(Get.find()));
    Get.lazyPut(() => GetStudentCourses(Get.find()));
    Get.lazyPut(() => GetPreviousCourseGradesUseCase(Get.find()));
    Get.lazyPut(() => GetPreviousSemesterGradesUseCase(Get.find()));

    Get.lazyPut(() => StudentGradeController(
          getStudentGradesUseCase: Get.find(),
          getAllGradesUseCase: Get.find(),
          getStudentCoursesUseCase: Get.find(),
          getPreviousCourseGradesUseCase: Get.find(),
          getPreviousSemesterGradesUseCase: Get.find(),
        ));
  }
}
