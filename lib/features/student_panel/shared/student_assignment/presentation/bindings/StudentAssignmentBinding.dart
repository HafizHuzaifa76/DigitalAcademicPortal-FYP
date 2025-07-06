import 'package:get/get.dart';
import '../../data/datasources/StudentAssignmentRemoteDataSource.dart';
import '../../data/repositories/StudentAssignmentRepositoryImpl.dart';
import '../../domain/repositories/StudentAssignmentRepository.dart';
import '../../domain/usecases/GetStudentAssignmentsUseCase.dart';
import '../../domain/usecases/SubmitStudentAssignmentUseCase.dart';
import '../controllers/StudentAssignmentController.dart';
import '../../../student_courses/data/datasources/StudentCoursesRemoteDataSource.dart';
import '../../../student_courses/data/repositories/StudentCoursesRepositoryImpl.dart';
import '../../../student_courses/domain/repositories/StudentCoursesRepository.dart';
import '../../../student_courses/domain/usecases/FetchStudentCoursesUseCase.dart';

class StudentAssignmentBinding extends Bindings {
  @override
  void dependencies() {
    // Student Courses dependencies
    Get.lazyPut<StudentCoursesRemoteDataSource>(
      () => StudentCoursesRemoteDataSourceImpl(),
    );
    Get.lazyPut<StudentCoursesRepository>(
      () => StudentCoursesRepositoryImpl(Get.find()),
    );
    Get.lazyPut(() => FetchStudentCoursesUseCase(Get.find()));

    // Student Assignment dependencies
    Get.lazyPut<StudentAssignmentRemoteDataSource>(
      () => StudentAssignmentRemoteDataSourceImpl(),
    );
    Get.lazyPut<StudentAssignmentRepository>(
      () => StudentAssignmentRepositoryImpl(Get.find()),
    );
    Get.lazyPut(() => GetStudentAssignmentsUseCase(Get.find()));
    Get.lazyPut(() => SubmitStudentAssignmentUseCase(Get.find()));
    Get.lazyPut(() => StudentAssignmentController(
          getAssignmentsUseCase: Get.find(),
          submitAssignmentUseCase: Get.find(),
          fetchStudentCoursesUseCase: Get.find(),
        ));
  }
}
