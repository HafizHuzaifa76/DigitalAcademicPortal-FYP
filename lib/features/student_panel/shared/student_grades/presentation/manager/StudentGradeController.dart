import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../presentation/pages/StudentPanelDashboardPage.dart';
import '../../domain/entities/StudentGrade.dart';
import '../../domain/entities/PreviousCourseGrade.dart';
import '../../domain/use_cases/GetStudentGradesUseCase.dart';
import '../../domain/use_cases/GetAllGradesUseCase.dart';
import '../../domain/use_cases/GetPreviousCourseGradesUseCase.dart';
import '../../domain/use_cases/GetPreviousSemesterGradesUseCase.dart';
import '../../../student_courses/domain/entities/StudentCourse.dart';
import '../../domain/use_cases/GetStudentCourses.dart';

class StudentGradeController extends GetxController {
  final GetStudentGradesUseCase getStudentGradesUseCase;
  final GetAllGradesUseCase getAllGradesUseCase;
  final GetStudentCourses getStudentCoursesUseCase;
  final GetPreviousCourseGradesUseCase getPreviousCourseGradesUseCase;
  final GetPreviousSemesterGradesUseCase getPreviousSemesterGradesUseCase;

  StudentGradeController({
    required this.getStudentGradesUseCase,
    required this.getAllGradesUseCase,
    required this.getStudentCoursesUseCase,
    required this.getPreviousCourseGradesUseCase,
    required this.getPreviousSemesterGradesUseCase,
  });

  var isLoading = false.obs;
  var studentCourses = <StudentCourse>[].obs;
  var student = StudentPortalDashboardPage.studentProfile;
  var currentGradesList = <StudentGrade>[].obs;
  var previousGradesList = <PreviousCourseGrade>[].obs;
  var selectedCourse = Rxn<StudentCourse>();
  var isCurrentSemester = true.obs;
  var selectedSemester = ''.obs;
  var categories = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadStudentCourses();
  }

  void setCurrentSemester(bool value) {
    isCurrentSemester.value = value;
    if (value) {
      loadStudentCourses();
    } else {
      loadPreviousGrades();
    }
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
          Get.snackbar('Error', failure.toString(),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        },
        (courses) {
          studentCourses.assignAll(courses);
          if (courses.isNotEmpty) {
            selectedCourse.value = courses.first;
            loadCurrentGrades();
          }
        },
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadCurrentGrades() async {
    if (selectedCourse.value == null) return;

    try {
      isLoading(true);
      final params = GetStudentGradesParams(
        studentId: student!.studentRollNo,
        courseId: selectedCourse.value!.courseName,
      );

      final result = await getStudentGradesUseCase.execute(params);

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.toString(),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        },
        (grades) {
          currentGradesList.assignAll(grades);
          // Extract unique categories
          categories.value = grades.map((g) => g.category).toSet().toList();
        },
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadPreviousGrades() async {
    try {
      isLoading(true);
      final params =
          GetPreviousCourseGradesParams(studentId: student!.studentRollNo);
      final result = await getPreviousCourseGradesUseCase.execute(params);

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.toString(),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        },
        (grades) {
          previousGradesList.assignAll(grades);
        },
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadPreviousSemesterGrades(String semester) async {
    try {
      isLoading(true);
      final params = GetPreviousSemesterGradesParams(
        studentId: student!.studentRollNo,
        semester: semester,
      );
      final result = await getPreviousSemesterGradesUseCase.execute(params);

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.toString(),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        },
        (grades) {
          previousGradesList.assignAll(grades);
        },
      );
    } finally {
      isLoading(false);
    }
  }

  void updateSelectedCourse(StudentCourse course) {
    selectedCourse.value = course;
    loadCurrentGrades();
  }

  void updateSelectedSemester(String semester) {
    selectedSemester.value = semester;
    loadPreviousSemesterGrades(semester);
  }

  List<StudentGrade> getGradesByCategory(String category) {
    return currentGradesList
        .where((grade) => grade.category == category)
        .toList();
  }

  double calculateGPA() {
    if (previousGradesList.isEmpty) return 0.0;
    double totalPoints = 0.0;
    int totalCourses = previousGradesList.length;

    for (var grade in previousGradesList) {
      if (grade.status.toUpperCase() == 'PASSED') {
        double percentage = (grade.totalMarks / 100) * 100;
        if (percentage >= 85)
          totalPoints += 4.0;
        else if (percentage >= 80)
          totalPoints += 3.5;
        else if (percentage >= 75)
          totalPoints += 3.0;
        else if (percentage >= 70)
          totalPoints += 2.5;
        else if (percentage >= 65)
          totalPoints += 2.0;
        else if (percentage >= 60)
          totalPoints += 1.5;
        else if (percentage >= 50) totalPoints += 1.0;
      }
    }

    return totalPoints / totalCourses;
  }
}
