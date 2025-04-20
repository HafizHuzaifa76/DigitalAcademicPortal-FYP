import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:get/get.dart';
import '../../domain/entities/TeacherCourse.dart';
import '../../domain/repositories/TeacherCourseRepository.dart';

class TeacherCourseController extends GetxController {
  final TeacherCourseRepository repository;
  final RxList<TeacherCourse> coursesList = <TeacherCourse>[].obs;
  final RxBool isLoading = false.obs;

  TeacherCourseController(this.repository);

  Future<void> getTeacherCourses(String teacherDept) async {
    isLoading.value = true;
    final result = await repository.getTeacherCourses(teacherDept);
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
}
