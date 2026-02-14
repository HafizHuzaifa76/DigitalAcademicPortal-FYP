import 'package:get/get.dart';
import '../../data/datasources/StudentCalendarEventRemoteDataSource.dart';
import '../../data/repositories/StudentCalendarEventRepositoryImpl.dart';
import '../../domain/repositories/StudentCalendarEventRepository.dart';
import '../../domain/usecases/GetAllCalendarEvents.dart';
import '../controllers/StudentCalendarEventController.dart';

class StudentCalendarEventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentCalendarEventRemoteDataSource>(
      () => StudentCalendarEventRemoteDataSourceImpl(),
    );

    Get.lazyPut<StudentCalendarEventRepository>(
      () => StudentCalendarEventRepositoryImpl(Get.find()),
    );

    Get.lazyPut(() => GetAllCalendarEvents(Get.find()));

    Get.lazyPut(() => StudentCalendarEventController(getAllEvents: Get.find()));
  }
}
