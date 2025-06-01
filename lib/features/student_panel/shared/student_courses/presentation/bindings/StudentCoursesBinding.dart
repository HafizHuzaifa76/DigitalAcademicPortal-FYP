import 'package:get/get.dart';
import '../../data/datasources/StudentCoursesRemoteDataSource.dart';
import '../../data/repositories/StudentCoursesRepositoryImpl.dart';
import '../../domain/repositories/StudentCoursesRepository.dart';
import '../../domain/usecases/FetchStudentCoursesUseCase.dart';
import '../controllers/StudentCoursesController.dart';

class StudentCoursesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentCoursesRemoteDataSource>(
      () => StudentCoursesRemoteDataSourceImpl(),
    );

    Get.lazyPut<StudentCoursesRepository>(
      () => StudentCoursesRepositoryImpl(Get.find()),
    );

    Get.lazyPut(() => FetchStudentCoursesUseCase(Get.find()));

    Get.lazyPut(() => StudentCoursesController(Get.find()));
  }
}
