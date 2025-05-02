import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../shared/domain/entities/Teacher.dart';
import '../../domain/usecases/GetTeacherPanelProfile.dart';

class TeacherDashboardController extends GetxController {
  final GetTeacherPanelProfile getTeacherPanelProfile;
  final Rxn<Teacher> teacher = Rxn<Teacher>();
  final RxBool isLoading = false.obs;

  TeacherDashboardController({required this.getTeacherPanelProfile});

  Future<void> loadTeacherProfile() async {
    isLoading.value = true;
    final result = await getTeacherPanelProfile.execute(null);
    
    result.fold(
      (failure) {
        Get.snackbar('Error', failure.toString());
      },
      (teacherData) {
        teacher.value = teacherData;
        print(teacherData.teacherCNIC);
        print(teacherData.teacherEmail);
        print(teacherData.toString());
      },
    );
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    loadTeacherProfile();
  }
}