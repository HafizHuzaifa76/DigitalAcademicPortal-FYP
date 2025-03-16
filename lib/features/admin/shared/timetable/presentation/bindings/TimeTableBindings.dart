
import 'package:get/get.dart';

import '../../data/datasources/TimeTableRemoteDataSource.dart';
import '../../data/repositories/TimeTableRepositoryImpl.dart';
import '../../domain/repositories/TimeTableRepository.dart';
import '../../domain/usecases/AddTimetableEntryUseCase.dart';
import '../../domain/usecases/AllTimetableEntryUseCase.dart';
import '../../domain/usecases/DeleteTimetableEntryUseCase.dart';
import '../../domain/usecases/EditTimetableEntryUseCase.dart';
import '../controllers/TimeTableController.dart';

class TimeTableBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut<TimeTableRemoteDataSource>(() => TimeTableRemoteDataSourceImpl());
    Get.lazyPut<TimeTableRepository>(() => TimeTableRepositoryImpl(timeTableRemoteDataSource: Get.find()));
    Get.lazyPut(() => AllTimeTablesUseCase(Get.find()));
    Get.lazyPut(() => AddTimeTableUseCase(Get.find()));
    Get.lazyPut(() => EditTimeTableUseCase(Get.find()));
    Get.lazyPut(() => DeleteTimeTableUseCase(Get.find()));
    Get.lazyPut(() => TimeTableController(addTimeTableUseCase: Get.find(), deleteTimeTableUseCase: Get.find(), editTimeTableUseCase: Get.find(), allTimeTablesUseCase: Get.find()));
  }

}