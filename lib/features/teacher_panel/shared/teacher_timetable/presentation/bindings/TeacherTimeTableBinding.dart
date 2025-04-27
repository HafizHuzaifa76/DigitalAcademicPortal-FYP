import 'package:get/get.dart';
import '../../data/datasources/TeacherTimeTableRemoteDataSource.dart';
import '../../data/repositories/TeacherTimeTableRepositoryImpl.dart';
import '../../domain/repositories/TeacherTimeTableRepository.dart';
import '../../domain/usecases/FetchTeacherTimetable.dart';
import '../controllers/TeacherTimeTableController.dart';

class TeacherTimeTableBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherTimeTableRemoteDataSource>(
      () => TeacherTimeTableRemoteDataSourceImpl(),
    );

    Get.lazyPut<TeacherTimeTableRepository>(
      () => TeacherTimeTableRepositoryImpl(Get.find()),
    );

    Get.lazyPut(() => FetchTeacherTimetable(Get.find()));

    Get.lazyPut(() => TeacherTimeTableController(Get.find()));
  }
}