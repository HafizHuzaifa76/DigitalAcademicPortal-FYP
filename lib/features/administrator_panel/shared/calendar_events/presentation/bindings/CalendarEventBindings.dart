
import 'package:get/get.dart';

import '../../data/datasources/CalendarEventRemoteDataSource.dart';
import '../../data/repositories/CalendarEventRepositoryImpl.dart';
import '../../domain/repositories/CalendarEventRepository.dart';
import '../../domain/usecases/AddCalendarEventUseCase.dart';
import '../../domain/usecases/AllCalendarEventUseCase.dart';
import '../../domain/usecases/DeleteCalendarEventUseCase.dart';
import '../../domain/usecases/EditCalendarEventUseCase.dart';
import '../controllers/CalendarEventController.dart';

class CalendarEventBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<CalendarEventRemoteDataSource>(() => CalendarEventRemoteDataSourceImpl());
    Get.lazyPut<CalendarEventRepository>(() => CalendarEventRepositoryImpl(remoteDataSource: Get.find()));
    Get.lazyPut(() => AllCalendarEventsUseCase(Get.find()));
    Get.lazyPut(() => AddCalendarEventUseCase(Get.find()));
    Get.lazyPut(() => EditCalendarEventUseCase(Get.find()));
    Get.lazyPut(() => DeleteCalendarEventUseCase(Get.find()));
    Get.lazyPut(() => CalendarEventController(addCalendarEventUseCase: Get.find(), deleteCalendarEventUseCase: Get.find(), updateCalendarEventUseCase: Get.find(), fetchCalendarEventsUseCase: Get.find()));
  }

}