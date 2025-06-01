import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:digital_academic_portal/features/teacher_panel/shared/teacher_attendance/domain/usecases/GetTeacherCoursesUseCase.dart';
import 'package:get/get.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import '../../domain/entities/TeacherAttendance.dart';
import '../../domain/usecases/GetAttendanceForDateUseCase.dart';
import '../../domain/usecases/MarkAttendanceUseCase.dart';

class TeacherAttendanceController extends GetxController {
  final GetTeacherCoursesUseCase getTeacherCoursesUseCase;
  final GetAttendanceForDateUseCase getAttendanceForDateUseCase;
  final MarkAttendanceUseCase markAttendanceUseCase;

  final RxList<TeacherAttendance> attendanceList = <TeacherAttendance>[].obs;
  final RxList<TeacherCourse> coursesList = <TeacherCourse>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rxn<TeacherCourse> selectedCourse = Rxn<TeacherCourse>();

  TeacherAttendanceController({
    required this.getTeacherCoursesUseCase,
    required this.getAttendanceForDateUseCase,
    required this.markAttendanceUseCase,
  });

  Future<void> getTeacherCourses(String teacherDept) async {
    isLoading.value = true;
    final result = await getTeacherCoursesUseCase.execute(teacherDept);
    result.fold(
      (failure) {
        Utils().showErrorSnackBar('Error', failure.toString());
        isLoading.value = false;
      },
      (courses) {
        coursesList.value = courses;
        print('courses length: ${courses.length}');
        isLoading.value = false;
      },
    );
  }

  Future<void> loadAttendance() async {
    if (selectedCourse.value == null) return;

    try {
      isLoading.value = true;
      final params = GetAttendanceForDateParams(
        courseId: selectedCourse.value!.courseName,
        courseSection: selectedCourse.value!.courseSection,
        date: selectedDate.value,
      );

      final result = await getAttendanceForDateUseCase.execute(params);
      result.fold(
        (failure) {
          Utils().showErrorSnackBar('Error', failure.toString());
        },
        (attendance) {
          if (attendance.isEmpty) {
            // If no attendance records exist for this date, create new ones for all students
            final newAttendance = selectedCourse.value!.studentIds
                .map((studentId) => TeacherAttendance(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      courseId: selectedCourse.value!.courseName,
                      studentId: studentId,
                      date: selectedDate.value,
                      isPresent: true, // Default to present
                      courseSection: selectedCourse.value!.courseSection,
                    ))
                .toList();
            attendanceList.assignAll(newAttendance);
          } else {
            attendanceList.assignAll(attendance);
          }
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAttendance() async {
    try {
      isLoading.value = true;
      final result = await markAttendanceUseCase.execute(attendanceList);
      result.fold(
        (failure) {
          Utils().showErrorSnackBar('Error', failure.toString());
        },
        (_) {
          Utils()
              .showSuccessSnackBar('Success', 'Attendance marked successfully');
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateStudentAttendance(String studentId, bool isPresent) {
    final index = attendanceList.indexWhere((a) => a.studentId == studentId);
    if (index != -1) {
      final attendance = attendanceList[index];
      attendanceList[index] = TeacherAttendance(
        id: attendance.id,
        courseId: attendance.courseId,
        studentId: attendance.studentId,
        date: attendance.date,
        isPresent: isPresent,
        courseSection: attendance.courseSection,
        remarks: attendance.remarks,
      );
    }
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
    loadAttendance();
  }

  void updateSelectedCourse(TeacherCourse course) {
    selectedCourse.value = course;
    loadAttendance();
  }
}
