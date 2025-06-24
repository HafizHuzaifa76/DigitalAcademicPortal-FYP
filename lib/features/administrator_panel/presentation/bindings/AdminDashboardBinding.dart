import 'package:get/get.dart';
import '../controllers/AdminDashboardController.dart';
import '../services/AdminDashboardService.dart';

class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminDashboardService>(() => AdminDashboardService());
    Get.lazyPut<AdminDashboardController>(() => AdminDashboardController());
  }
}
