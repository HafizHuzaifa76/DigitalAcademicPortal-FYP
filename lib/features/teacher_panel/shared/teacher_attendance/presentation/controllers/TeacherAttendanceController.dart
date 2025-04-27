import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:digital_academic_portal/features/teacher_panel/shared/teacher_attendance/domain/usecases/GetTeacherCoursesUseCase.dart';
import 'package:get/get.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import '../../domain/entities/TeacherAttendance.dart';
import '../../domain/usecases/GetTeacherAttendanceUseCase.dart';

class TeacherAttendanceController extends GetxController {
  final GetTeacherAttendanceUseCase getTeacherAttendanceUseCase;
  final GetTeacherCoursesUseCase getTeacherCoursesUseCase;
  final RxList<TeacherAttendance> attendanceList = <TeacherAttendance>[].obs;
  final RxList<TeacherCourse> coursesList = <TeacherCourse>[].obs;
  final RxBool isLoading = false.obs;

  final Rxn<TeacherCourse> selectedCourse = Rxn<TeacherCourse>();


  TeacherAttendanceController({required this.getTeacherAttendanceUseCase, required  this.getTeacherCoursesUseCase});


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

  Future<void> loadTeacherAttendance() async {
    // Implementation will go here
  }


}