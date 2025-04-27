import 'package:dartz/dartz.dart';
import '../../../../../../core/usecases/UseCase.dart';
import '../entities/TeacherCourse.dart';
import '../repositories/TeacherCourseRepository.dart';

class FetchAllTeacherCoursesUseCase
    implements UseCase<List<TeacherCourse>, String> {
  final TeacherCourseRepository repository;

  FetchAllTeacherCoursesUseCase(this.repository);

  @override
  Future<Either<Fail, List<TeacherCourse>>> execute(String teacherDept) async {
    return await repository.getTeacherCourses(teacherDept);
  }
}
