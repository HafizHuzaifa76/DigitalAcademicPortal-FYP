import 'package:digital_academic_portal/features/student_panel/presentation/pages/StudentPanelDashboardPage.dart';
import 'package:digital_academic_portal/shared/domain/entities/Student.dart';
import 'package:get/get.dart';
import '../../../../core/utils/Utils.dart';
import '../../domain/usecases/GetStudentPanelProfile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../core/services/SharedPrefService.dart';

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
    List<String> topics = await SharedPrefService.getTopics();
    print('topics');
    print(topics);

    final result = await getStudentPanelProfile.execute(null);

    result.fold(
      (failure) {
        Utils().showErrorSnackBar('Error', failure.failure.toString());
      },
      (studentData) async {
        student.value = studentData;
        StudentPortalDashboardPage.studentProfile = studentData;
        print(studentData.studentCNIC);

        final sectionTopic =
            'Section-${studentData.studentSemester}-${studentData.studentSection}'
                .toLowerCase()
                .replaceAll(" ", "-");
        print(sectionTopic);
        bool isSubscribed = await SharedPrefService.isSubscribed(sectionTopic);
        print(isSubscribed);

        if (!isSubscribed) {
          await FirebaseMessaging.instance.subscribeToTopic(sectionTopic).then(
              (value) async => await SharedPrefService.addTopic(sectionTopic));
        }
      },
    );
    isLoading.value = false;
  }
}
