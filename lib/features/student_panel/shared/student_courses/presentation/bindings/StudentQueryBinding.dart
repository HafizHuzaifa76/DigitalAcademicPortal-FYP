import 'package:get/get.dart';
import '../../data/datasources/StudentQueryRemoteDataSource.dart';
import '../../data/repositories/StudentQueryRepositoryImpl.dart';
import '../../domain/repositories/StudentQueryRepository.dart';
import '../../domain/usecases/GetStudentQueriesUseCase.dart';
import '../../domain/usecases/AskStudentQueryUseCase.dart';
import '../controllers/StudentQueryController.dart';

class StudentQueryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentQueryRemoteDataSource>(
        () => StudentQueryRemoteDataSourceImpl());
    Get.lazyPut<StudentQueryRepository>(
        () => StudentQueryRepositoryImpl(remoteDataSource: Get.find()));
    Get.lazyPut(() => GetStudentQueriesUseCase(Get.find()));
    Get.lazyPut(() => AskStudentQueryUseCase(Get.find()));
    Get.lazyPut(() => StudentQueryController(
          getQueriesUseCase: Get.find(),
          askQueryUseCase: Get.find(),
        ));
  }
}
