import 'package:digital_academic_portal/features/teacher_panel/presentation/controllers/TeacherDashboardController.dart';
import 'package:get/get.dart';

class TeacherDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeacherDashboardController());
  }
}
