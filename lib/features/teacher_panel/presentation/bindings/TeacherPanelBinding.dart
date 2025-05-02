import 'package:digital_academic_portal/features/teacher_panel/presentation/controllers/TeacherDashboardController.dart';
import 'package:get/get.dart';
import '../../data/datasources/TeacherPanelRemoteDataSource.dart';
import '../../data/repositories/TeacherPanelRepositoryImpl.dart';
import '../../domain/repositories/TeacherPanelRepository.dart';
import '../../domain/usecases/GetTeacherPanelProfile.dart';

class TeacherPanelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherPanelRemoteDataSource>(
      () => TeacherPanelRemoteDataSourceImpl(),
    );

    Get.lazyPut<TeacherPanelRepository>(
      () => TeacherPanelRepositoryImpl(Get.find()),
    );

    Get.lazyPut(() => GetTeacherPanelProfile(Get.find()));

    Get.lazyPut(() => TeacherDashboardController(getTeacherPanelProfile: Get.find()));
  }
}
