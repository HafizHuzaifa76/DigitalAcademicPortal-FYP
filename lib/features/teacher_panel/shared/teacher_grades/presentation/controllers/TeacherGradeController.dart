import 'dart:math';

import 'package:get/get.dart';
import '../../domain/entities/Grade.dart';
import '../../domain/usecases/GetMarkingGradesUseCase.dart';
import '../../domain/usecases/SaveMarkingGradesUseCase.dart';
import '../../domain/usecases/GetCourseGradesUseCase.dart';
import '../../domain/usecases/CreateCourseGradeUseCase.dart';
import '../../domain/usecases/DeleteGradeUseCase.dart';
import '../../domain/usecases/UpdateGradeUseCase.dart';
import '../../domain/usecases/GetTeacherCoursesUseCase.dart';
import 'package:digital_academic_portal/core/utils/Utils.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import '../pages/StudentGradingPage.dart';
import '../../domain/usecases/SubmitCourseGradesUseCase.dart';
import '../../../../../../shared/data/models/PreviousCourseGradeModel.dart';
import '../../../../presentation/pages/TeacherDashboardPage.dart';

class TeacherGradeController extends GetxController {
  final GetMarkingGradesUseCase getMarkingGradesUseCase;
  final SaveMarkingGradesUseCase saveMarkingGradesUseCase;
  final GetCourseGradesUseCase getCourseGradesUseCase;
  final CreateCourseGradeUseCase createCourseGradeUseCase;
  final DeleteGradeUseCase deleteGradeUseCase;
  final UpdateGradeUseCase updateGradeUseCase;
  final GetTeacherCoursesUseCase getTeacherCoursesUseCase;
  final SubmitCourseGradesUseCase submitCourseGradesUseCase;

  final RxList<Grade> gradesList = <Grade>[].obs;
  final RxList<TeacherCourse> coursesList = <TeacherCourse>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString selectedCourseId = ''.obs;
  final RxString selectedGradeId = ''.obs;
  final Rxn<TeacherCourse> selectedCourse = Rxn<TeacherCourse>();

  TeacherGradeController({
    required this.getMarkingGradesUseCase,
    required this.saveMarkingGradesUseCase,
    required this.getCourseGradesUseCase,
    required this.createCourseGradeUseCase,
    required this.deleteGradeUseCase,
    required this.updateGradeUseCase,
    required this.getTeacherCoursesUseCase,
    required this.submitCourseGradesUseCase,
  });

  Future<void> getTeacherCourses(String teacherDept) async {
    isLoading.value = true;
    final result = await getTeacherCoursesUseCase.execute(teacherDept);
    result.fold(
      (failure) {
        Utils().showErrorSnackBar('Error', failure.failure.toString());
        isLoading.value = false;
      },
      (courses) {
        coursesList.value = courses;
        isLoading.value = false;
      },
    );
  }

  Future<Grade?> createGrades(Grade grade) async {
    try {
      isLoading.value = true;
      if (selectedCourse.value == null) {
        throw Exception('No course selected');
      }

      // Initialize obtained marks for all students
      final initialMarks = <String, dynamic>{};
      for (var studentId in selectedCourse.value!.studentIds) {
        initialMarks[studentId] = 0;
      }

      // Create grade with initial marks
      final gradeWithMarks = grade.copyWith(obtainedMarks: initialMarks);

      final params = CreateCourseGradeParams(
        course: selectedCourse.value!,
        grade: gradeWithMarks,
      );

      final result = await createCourseGradeUseCase.execute(params);
      return result.fold(
        (failure) {
          Utils().showErrorSnackBar('Error', failure.failure.toString());
          isLoading.value = false;
          return null;
        },
        (_) {
          Utils().showSuccessSnackBar('Success', 'Grade created successfully');
          loadGrades(selectedCourse.value!.courseName);
          isLoading.value = false;
          return gradeWithMarks;
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadGrades(String courseId) async {
    try {
      isLoading.value = true;
      if (selectedCourse.value == null) {
        throw Exception('No course selected');
      }

      final result =
          await getCourseGradesUseCase.execute(selectedCourse.value!);
      result.fold(
        (failure) {
          Utils().showErrorSnackBar('Error', failure.failure.toString());
        },
        (grades) {
          gradesList.assignAll(grades);
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveGrades(Grade grade, Map<String, dynamic> marks) async {
    try {
      isLoading.value = true;
      if (selectedCourse.value == null) {
        throw Exception('No course selected');
      }

      final updatedGrade = grade.copyWith(obtainedMarks: marks);
      final params = SaveMarkingGradesParams(
        course: selectedCourse.value!,
        gradeId: grade.id,
        obtainedGrades: marks,
      );

      final result = await saveMarkingGradesUseCase.execute(params);
      result.fold(
        (failure) {
          Utils().showErrorSnackBar('Error', failure.failure.toString());
        },
        (_) {
          Utils().showSuccessSnackBar('Success', 'Grades saved successfully');
          // Update the grade in the list
          final index = gradesList.indexWhere((g) => g.id == grade.id);
          if (index != -1) {
            gradesList[index] = updatedGrade;
          }
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateSelectedCourse(TeacherCourse course) {
    selectedCourse.value = course;
    selectedCourseId.value = course.courseName;
    loadGrades(course.courseName);
  }

  Future<void> updateGrade(Grade grade) async {
    try {
      isLoading.value = true;
      if (selectedCourse.value == null) {
        throw Exception('No course selected');
      }

      final params = UpdateGradeParams(
        course: selectedCourse.value!,
        grade: grade,
      );

      final result = await updateGradeUseCase.execute(params);
      result.fold(
        (failure) {
          Utils().showErrorSnackBar('Error', failure.failure.toString());
        },
        (_) {
          Utils().showSuccessSnackBar('Success', 'Grade updated successfully');
          // Update the grade in the list
          final index = gradesList.indexWhere((g) => g.id == grade.id);
          if (index != -1) {
            gradesList[index] = grade;
          }
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteGrade(Grade grade) async {
    try {
      isLoading.value = true;
      if (selectedCourse.value == null) {
        throw Exception('No course selected');
      }

      final result = await deleteGradeUseCase.execute(
        DeleteGradeParams(
          course: selectedCourse.value!,
          gradeId: grade.id,
        ),
      );

      result.fold(
        (failure) {
          Utils().showErrorSnackBar('Error', failure.failure.toString());
        },
        (_) {
          Utils().showSuccessSnackBar('Success', 'Grade deleted successfully');
          // Remove the grade from the list
          gradesList.removeWhere((g) => g.id == grade.id);
          Get.back(); // Go back to previous screen
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitCourseGrades(List<PreviousCourseGradeModel> grades) async {
    isSubmitting.value = true;
    if (selectedCourse.value == null) {
      Utils().showErrorSnackBar('Error', 'No course selected');
      isSubmitting.value = false;
      return;
    }

    final params = SubmitCourseGradesParams(
      grades: grades,
      course: selectedCourse.value!,
    );

    final result = await submitCourseGradesUseCase.execute(params);
    result.fold(
      (failure) {
        Utils().showErrorSnackBar('Error', failure.failure.toString());
        isSubmitting.value = false;
      },
      (_) {
        Utils().showSuccessSnackBar('Success', 'Grades submitted successfully');
        // Close both screens and navigate back to TeacherGradePage
        Get.until((route) => route.settings.name == '/teacherGradePage');
        // Refresh teacher courses since the submitted course will be removed
        if (TeacherDashboardPage.teacherProfile != null) {
          getTeacherCourses(TeacherDashboardPage.teacherProfile!.teacherDept);
        }
        // Clear selected course since it's no longer accessible
        selectedCourse.value = null;
        selectedCourseId.value = '';
        gradesList.clear();
        isSubmitting.value = false;
      },
    );
  }
}
