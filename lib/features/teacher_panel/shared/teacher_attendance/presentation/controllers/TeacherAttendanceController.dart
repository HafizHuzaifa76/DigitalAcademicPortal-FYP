import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:digital_academic_portal/features/teacher_panel/shared/teacher_attendance/domain/usecases/GetTeacherCoursesUseCase.dart';
import 'package:get/get.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import '../../../../../../shared/domain/entities/Attendance.dart';
import '../../domain/usecases/GetCourseAttendanceUseCase.dart';
import '../../domain/usecases/MarkAttendanceUseCase.dart';

class TeacherAttendanceController extends GetxController {
  final GetTeacherCoursesUseCase getTeacherCoursesUseCase;
  final GetCourseAttendanceUseCase getCourseAttendanceUseCase;
  final MarkAttendanceUseCase markAttendanceUseCase;

  final RxMap<String, List<Attendance>> attendanceMap =
      <String, List<Attendance>>{}.obs;
  final RxList<Attendance> filteredAttendanceList = <Attendance>[].obs;
  final RxList<TeacherCourse> coursesList = <TeacherCourse>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rxn<TeacherCourse> selectedCourse = Rxn<TeacherCourse>();
  final RxBool isAllMarked = false.obs;
  final RxBool isExistingAttendance = false.obs;

  TeacherAttendanceController({
    required this.getTeacherCoursesUseCase,
    required this.getCourseAttendanceUseCase,
    required this.markAttendanceUseCase,
  }) {
    selectedDate.value = getLastValidDate(DateTime.now());
  }

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
        print('courses length: ${courses.length}');
        isLoading.value = false;
      },
    );
  }

  Future<void> loadAttendance() async {
    if (selectedCourse.value == null) return;

    try {
      isLoading.value = true;
      final params = GetCourseAttendanceParams(
        courseId: selectedCourse.value!.courseName,
        studentIds: selectedCourse.value!.studentIds,
        semester: selectedCourse.value!.courseSemester,
        section: selectedCourse.value!.courseSection,
      );

      final result = await getCourseAttendanceUseCase.execute(params);
      result.fold(
        (failure) {
          Utils().showErrorSnackBar('Error', failure.failure.toString());
        },
        (attendanceData) {
          attendanceMap.assignAll(attendanceData);
          print(attendanceData.keys.length);
          _updateFilteredList();
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _updateFilteredList() {
    final dateKey = selectedDate.value.toIso8601String();
    if (attendanceMap.containsKey(dateKey)) {
      filteredAttendanceList.assignAll(attendanceMap[dateKey]!);
      isExistingAttendance.value = true;
      // Check if all students are marked present
      isAllMarked.value =
          filteredAttendanceList.every((attendance) => attendance.isPresent);
    } else {
      // If no attendance records exist for this date, create new ones for all students
      final newAttendance = selectedCourse.value!.studentIds
          .map((studentId) => Attendance(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                course: selectedCourse.value!.courseName,
                studentId: studentId,
                date: selectedDate.value,
                isPresent: false,
                remarks: null,
              ))
          .toList();
      filteredAttendanceList.assignAll(newAttendance);
      isExistingAttendance.value = false;
      isAllMarked.value = false;
    }
  }

  Future<void> markAttendance() async {
    if (selectedCourse.value == null) return;

    try {
      isLoading.value = true;
      final params = MarkAttendanceParams(
        semester: selectedCourse.value!.courseSemester,
        section: selectedCourse.value!.courseSection,
        attendanceList: filteredAttendanceList,
      );

      final result = await markAttendanceUseCase.execute(params);
      result.fold(
        (failure) {
          Utils().showErrorSnackBar('Error', failure.failure.toString());
        },
        (_) {
          // Update the local map after successful marking
          attendanceMap[selectedDate.value.toIso8601String()] =
              filteredAttendanceList.toList();
          isExistingAttendance.value = true;
          Utils().showSuccessSnackBar(
              'Success',
              isExistingAttendance.value
                  ? 'Attendance updated successfully'
                  : 'Attendance marked successfully');
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateStudentAttendance(String studentId, bool isPresent) {
    final index =
        filteredAttendanceList.indexWhere((a) => a.studentId == studentId);
    if (index != -1) {
      final attendance = filteredAttendanceList[index];
      filteredAttendanceList[index] = Attendance(
        id: attendance.id,
        course: attendance.course,
        studentId: attendance.studentId,
        date: attendance.date,
        isPresent: isPresent,
        remarks: attendance.remarks,
      );
    }
  }

  DateTime getLastValidDate(DateTime date) {
    // If current date is not Tuesday or Thursday, find the last valid date
    while (
        date.weekday != DateTime.tuesday && date.weekday != DateTime.thursday) {
      date = date.subtract(const Duration(days: 1));
    }
    return DateTime(date.year, date.month, date.day);
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
    _updateFilteredList();
  }

  void updateSelectedCourse(TeacherCourse course) {
    selectedCourse.value = course;

    selectedDate.value = getLastValidDate(DateTime.now());
    loadAttendance();
  }

  void markAllPresent() {
    for (var i = 0; i < filteredAttendanceList.length; i++) {
      final attendance = filteredAttendanceList[i];
      filteredAttendanceList[i] = Attendance(
        id: attendance.id,
        course: attendance.course,
        studentId: attendance.studentId,
        date: attendance.date,
        isPresent: true,
        remarks: attendance.remarks,
      );
    }
  }

  void toggleAllAttendance() {
    isAllMarked.value = !isAllMarked.value;
    for (var i = 0; i < filteredAttendanceList.length; i++) {
      final attendance = filteredAttendanceList[i];
      filteredAttendanceList[i] = Attendance(
        id: attendance.id,
        course: attendance.course,
        studentId: attendance.studentId,
        date: attendance.date,
        isPresent: isAllMarked.value,
        remarks: attendance.remarks,
      );
    }
  }
}
