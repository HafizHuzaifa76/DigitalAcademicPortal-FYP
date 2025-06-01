import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../presentation/pages/StudentPanelDashboardPage.dart';
import '../../domain/entities/StudentAttendance.dart';
import '../../domain/use_cases/GetStudentAttendanceUseCase.dart';
import '../../domain/use_cases/GetStudentCourses.dart';
import '../../../student_courses/domain/entities/StudentCourse.dart';

class StudentAttendanceController extends GetxController {
  final GetStudentAttendanceUseCase getStudentAttendanceUseCase;
  final GetStudentCourses getStudentCoursesUseCase;

  StudentAttendanceController({
    required this.getStudentAttendanceUseCase,
    required this.getStudentCoursesUseCase,
  });

  var isLoading = false.obs;
  var studentCourses = <StudentCourse>[].obs;
  var student = StudentPortalDashboardPage.studentProfile;
  var attendanceList = <StudentAttendance>[].obs;
  var selectedCourse = Rxn<StudentCourse>();

  @override
  void onInit() {
    super.onInit();
    loadStudentCourses();
  }

  Future<void> loadStudentCourses() async {
    try {
      if (student == null) {
        throw Exception('Student is null');
      }
      isLoading(true);
      final result =
          await getStudentCoursesUseCase.execute(student!.studentDepartment);

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.failure.toString(),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        },
        (courses) {
          studentCourses.assignAll(courses);
          if (courses.isNotEmpty) {
            selectedCourse.value = courses.first;
            loadAttendance();
          }
        },
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadAttendance() async {
    if (selectedCourse.value == null) return;

    try {
      isLoading(true);
      final params = GetStudentAttendanceParams(
        courseId: selectedCourse.value!.courseName,
      );

      final result = await getStudentAttendanceUseCase.execute(params);

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.toString(),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        },
        (attendance) {
          attendanceList.assignAll(attendance);
        },
      );
    } finally {
      isLoading(false);
    }
  }

  void updateSelectedCourse(StudentCourse course) {
    selectedCourse.value = course;
    loadAttendance();
  }

  double calculateAttendancePercentage() {
    if (attendanceList.isEmpty) return 0.0;
    int totalPresent = attendanceList.where((a) => a.isPresent).length;
    return (totalPresent / attendanceList.length) * 100;
  }
}
