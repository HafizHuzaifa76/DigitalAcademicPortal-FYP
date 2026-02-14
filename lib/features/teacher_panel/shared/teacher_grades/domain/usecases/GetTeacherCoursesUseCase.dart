import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/features/teacher_panel/shared/teacher_courses/domain/usecases/FetchAllTeacherCoursesUseCase.dart';
import '../../../../../../core/usecases/UseCase.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';

class GetTeacherCoursesUseCase implements UseCase<List<TeacherCourse>, String> {
  final FetchAllTeacherCoursesUseCase fetchAllTeacherCourses;

  GetTeacherCoursesUseCase(this.fetchAllTeacherCourses);

  @override
  Future<Either<Fail, List<TeacherCourse>>> execute(String teacherDept) async {
    return await fetchAllTeacherCourses.execute(teacherDept);
  }
}
