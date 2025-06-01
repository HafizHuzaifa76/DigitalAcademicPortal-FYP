import 'package:digital_academic_portal/features/student_panel/data/repositories/StudentPanelRepositoryImpl.dart';
import 'package:digital_academic_portal/features/student_panel/domain/repositories/StudentPanelRepository.dart';
import 'package:digital_academic_portal/features/student_panel/domain/usecases/GetStudentPanelProfile.dart';
import 'package:digital_academic_portal/features/student_panel/presentation/controller/StudentPanelController.dart';
import 'package:get/get.dart';
import '../../data/datasources/StudentPanelRemoteDataSource.dart';

class StudentPanelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentPanelRemoteDataSource>(
      () => StudentPanelRemoteDataSourceImpl(),
    );

    Get.lazyPut<StudentPanelRepository>(
      () => StudentPanelRepositoryImpl(Get.find()),
    );

    Get.lazyPut(() => GetStudentPanelProfile(Get.find()));

    Get.lazyPut(() => StudentDashboardController(getStudentPanelProfile: Get.find()));
  }
}
