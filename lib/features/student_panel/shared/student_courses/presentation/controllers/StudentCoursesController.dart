import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:get/get.dart';
import '../../domain/entities/StudentCourse.dart';
import '../../domain/usecases/FetchStudentCoursesUseCase.dart';

class StudentCoursesController extends GetxController {
  final FetchStudentCoursesUseCase fetchAllStudentCoursesUseCase;
  final RxList<StudentCourse> coursesList = <StudentCourse>[].obs;
  final RxBool isLoading = false.obs;

  StudentCoursesController(this.fetchAllStudentCoursesUseCase);

  Future<void> fetchStudentCourses(String studentDept) async {
    isLoading.value = true;
    final result = await fetchAllStudentCoursesUseCase.execute(studentDept);
    result.fold(
      (failure) =>
          Utils().showErrorSnackBar('Error', failure.failure.toString()),
      (courses) => coursesList.value = courses,
    );
    isLoading.value = false;
  }
}
