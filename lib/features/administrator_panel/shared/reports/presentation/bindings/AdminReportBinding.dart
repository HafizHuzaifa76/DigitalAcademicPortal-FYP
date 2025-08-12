import 'package:get/get.dart';
import '../../data/datasources/AdminReportRemoteDataSource.dart';
import '../../data/repositories/AdminReportRepositoryImpl.dart';
import '../../domain/repositories/AdminReportRepository.dart';
import '../../domain/usecases/FetchUnrespondedReportsUseCase.dart';
import '../../domain/usecases/RespondToReportUseCase.dart';
import '../controllers/AdminReportController.dart';

class AdminReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminReportRemoteDataSource());
    Get.lazyPut<AdminReportRepository>(
        () => AdminReportRepositoryImpl(Get.find()));
    Get.lazyPut(() => FetchUnrespondedReportsUseCase(Get.find()));
    Get.lazyPut(() => RespondToReportUseCase(Get.find()));
    Get.lazyPut(() => AdminReportController(
          fetchUnrespondedReportsUseCase: Get.find(),
          respondToReportUseCase: Get.find(),
        ));
  }
}
