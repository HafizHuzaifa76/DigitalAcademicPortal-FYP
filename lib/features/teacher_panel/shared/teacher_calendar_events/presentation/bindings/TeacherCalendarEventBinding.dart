import 'package:get/get.dart';
import '../../data/datasources/TeacherCalendarEventRemoteDataSource.dart';
import '../../data/repositories/TeacherCalendarEventRepositoryImpl.dart';
import '../../domain/repositories/TeacherCalendarEventRepository.dart';
import '../../domain/usecases/GetAllCalendarEvents.dart';
import '../controllers/TeacherCalendarEventController.dart';

class TeacherCalendarEventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherCalendarEventRemoteDataSource>(
      () => TeacherCalendarEventRemoteDataSourceImpl(),
    );

    Get.lazyPut<TeacherCalendarEventRepository>(
      () => TeacherCalendarEventRepositoryImpl(Get.find()),
    );

    Get.lazyPut(() => GetAllCalendarEvents(Get.find()));

    Get.lazyPut(() => TeacherCalendarEventController(getAllEvents: Get.find()));
  }
}
