import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/utils/Utils.dart';
import '../../domain/entities/StudentAssignment.dart';
import '../../../student_courses/domain/entities/StudentCourse.dart';
import '../../../student_courses/domain/usecases/FetchStudentCoursesUseCase.dart';
import '../../domain/usecases/GetStudentAssignmentsUseCase.dart';
import '../../domain/usecases/SubmitStudentAssignmentUseCase.dart';
import '../../../../presentation/pages/StudentPanelDashboardPage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class StudentAssignmentController extends GetxController {
  final GetStudentAssignmentsUseCase getAssignmentsUseCase;
  final SubmitStudentAssignmentUseCase submitAssignmentUseCase;
  final FetchStudentCoursesUseCase fetchStudentCoursesUseCase;

  StudentAssignmentController({
    required this.getAssignmentsUseCase,
    required this.submitAssignmentUseCase,
    required this.fetchStudentCoursesUseCase,
  });

  var assignments = <StudentAssignment>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  var studentCourses = <StudentCourse>[].obs;
  var selectedCourse = Rxn<StudentCourse>();
  var student = StudentPortalDashboardPage.studentProfile;

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
          await fetchStudentCoursesUseCase.execute(student!.studentDepartment);

      result.fold(
        (failure) {
          error.value = failure.failure.toString();
          Get.snackbar('Error', failure.failure.toString(),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        },
        (courses) {
          studentCourses.assignAll(courses);
          if (courses.isNotEmpty) {
            selectedCourse.value = courses.first;
            fetchAssignments();
          }
        },
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchAssignments() async {
    if (selectedCourse.value == null) return;

    isLoading.value = true;
    error.value = '';

    final result = await getAssignmentsUseCase.execute(selectedCourse.value!);
    result.fold(
      (failure) => error.value = failure.failure.toString(),
      (data) => assignments.value = data,
    );
    isLoading.value = false;
  }

  void updateSelectedCourse(StudentCourse course) {
    selectedCourse.value = course;
    fetchAssignments();
  }

  Future<void> submitAssignment(String assignmentId, var fileUrl) async {
    if (selectedCourse.value == null) {
      Get.snackbar(
        'Error',
        'Please select a course first',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    final result = await submitAssignmentUseCase.execute(
      SubmitAssignmentParams(
        assignmentId: assignmentId,
        fileUrl: fileUrl,
        course: selectedCourse.value!,
      ),
    );
    result.fold(
      (failure) => error.value = failure.failure.toString(),
      (_) {
        // Refresh assignments after successful submission
        fetchAssignments();
      },
    );
    isLoading.value = false;
  }

    
Future<void> downloadAndOpenFile(String url) async {
  try {
    EasyLoading.show(status: 'Opening File...');
    String fileName = url.split('/').last;
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var dir = await getTemporaryDirectory();

      File file = File('${dir.path}/$fileName');
      await file.writeAsBytes(response.bodyBytes);
      OpenFile.open(file.path);
    } else {
      Utils().showErrorSnackBar(
        'Error',
        'Failed to download file. Status code: ${response.statusCode}');
    }
  } catch (e) {
      Utils().showErrorSnackBar(
        'Error',
        'Error downloading or opening file: $e');
  }

  finally {
    EasyLoading.dismiss();
  }
}

}
