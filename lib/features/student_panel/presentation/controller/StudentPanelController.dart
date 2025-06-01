import 'package:digital_academic_portal/features/student_panel/presentation/pages/StudentPanelDashboardPage.dart';
import 'package:digital_academic_portal/shared/domain/entities/Student.dart';
import 'package:get/get.dart';
import '../../../../core/utils/Utils.dart';
import '../../domain/usecases/GetStudentPanelProfile.dart';

class StudentDashboardController extends GetxController {
  final GetStudentPanelProfile getStudentPanelProfile;
  final Rxn<Student> student = Rxn<Student>();
  final RxBool isLoading = false.obs;

  StudentDashboardController({required this.getStudentPanelProfile});

  @override
  void onInit() {
    super.onInit();
    loadStudentProfile();
  }

  Future<void> loadStudentProfile() async {
    isLoading.value = true;
    final result = await getStudentPanelProfile.execute(null);

    result.fold(
      (failure) {
        Utils().showErrorSnackBar('Error', failure.failure.toString());
      },
      (studentData) {
        student.value = studentData;
        StudentPortalDashboardPage.studentProfile = studentData;
        print(studentData.studentCNIC);
        print(studentData.studentEmail);
        print(studentData.toString());
      },
    );
    isLoading.value = false;
  }
}
