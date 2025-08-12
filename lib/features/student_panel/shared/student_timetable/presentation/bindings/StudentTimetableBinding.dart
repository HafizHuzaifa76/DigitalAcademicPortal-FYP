import 'package:get/get.dart';
import '../../data/datasources/StudentTimetableRemoteDataSource.dart';
import '../../data/repositories/StudentTimetableRepositoryImpl.dart';
import '../../domain/repositories/StudentTimetableRepository.dart';
import '../../domain/usecases/FetchStudentTimetable.dart';
import '../controllers/StudentTimetableController.dart';

class StudentTimetableBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentTimetableRemoteDataSource>(
      () => StudentTimetableRemoteDataSourceImpl(),
    );

    Get.lazyPut<StudentTimetableRepository>(
      () => StudentTimetableRepositoryImpl(Get.find()),
    );

    Get.lazyPut(() => FetchStudentTimetable(Get.find()));

    Get.lazyPut(() => StudentTimetableController(Get.find()));
  }
}
