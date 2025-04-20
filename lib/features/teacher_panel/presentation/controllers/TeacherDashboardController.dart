import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeacherDashboardController extends GetxController {
  var count = 0.obs;
  var teacherEmail = ''.obs;
  var teacherName = ''.obs;
  var teacherDept = ''.obs;

  void teacherData() {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      teacherEmail.value = currentUser.email ?? '';
      var displayName = currentUser.displayName ?? '';

      List<String> parts = displayName.split(' | ');
      if (parts.length > 2) {
        teacherName.value = parts[2];
        teacherDept.value = parts[1];
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    teacherData(); // Fetch user data when controller initializes
  }
}
