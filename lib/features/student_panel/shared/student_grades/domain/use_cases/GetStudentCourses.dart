import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/features/student_panel/shared/student_courses/domain/usecases/FetchStudentCoursesUseCase.dart';
import '../../../../../../core/usecases/UseCase.dart';
import '../../../student_courses/domain/entities/StudentCourse.dart';


class GetStudentCourses implements UseCase<List<StudentCourse>, String> {
  final FetchStudentCoursesUseCase usecase;

  GetStudentCourses(this.usecase);

  @override
  Future<Either<Fail, List<StudentCourse>>> execute(String studentDept) async {
    return await usecase.execute(studentDept);
  }
}