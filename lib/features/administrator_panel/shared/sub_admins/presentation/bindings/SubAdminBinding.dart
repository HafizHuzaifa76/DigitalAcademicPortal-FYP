import 'package:get/get.dart';
import '../../data/datasources/SubAdminRemoteDataSource.dart';
import '../../data/repositories/SubAdminRepositoryImpl.dart';
import '../../domain/repositories/SubAdminRepository.dart';
import '../../domain/usecases/FetchSubAdminsUseCase.dart';
import '../../domain/usecases/AddSubAdminUseCase.dart';
import '../../domain/usecases/DeleteSubAdminUseCase.dart';
import '../controllers/SubAdminController.dart';

class SubAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SubAdminRemoteDataSource());
    Get.lazyPut<SubAdminRepository>(() => SubAdminRepositoryImpl(Get.find()));
    Get.lazyPut(() => FetchSubAdminsUseCase(Get.find()));
    Get.lazyPut(() => AddSubAdminUseCase(Get.find()));
    Get.lazyPut(() => DeleteSubAdminUseCase(Get.find()));
    Get.lazyPut(() => SubAdminController(
          fetchSubAdminsUseCase: Get.find(),
          addSubAdminUseCase: Get.find(),
          deleteSubAdminUseCase: Get.find(),
        ));
  }
}
