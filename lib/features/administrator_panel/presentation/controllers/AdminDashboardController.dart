import 'package:get/get.dart';
import '../services/AdminDashboardService.dart';

class AdminDashboardController extends GetxController {
  final AdminDashboardService _adminDashboardService =
      Get.find<AdminDashboardService>();

  final RxInt departmentsCount = 0.obs;
  final RxInt teachersCount = 0.obs;
  final RxInt studentsCount = 0.obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardStats();
  }

  Future<void> loadDashboardStats() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final stats = await _adminDashboardService.getDashboardStats();

      departmentsCount.value = stats['departments'] ?? 0;
      teachersCount.value = stats['teachers'] ?? 0;
      studentsCount.value = stats['students'] ?? 0;

      isLoading.value = false;
    } catch (e) {
      print('Error loading dashboard stats: $e');
      errorMessage.value = 'Failed to load dashboard statistics';
      isLoading.value = false;
    }
  }

  void refreshStats() {
    loadDashboardStats();
  }

  bool get hasError => errorMessage.value.isNotEmpty;
}
