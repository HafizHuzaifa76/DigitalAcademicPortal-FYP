import 'package:dartz/dartz.dart';
import '../../../../../../core/usecases/UseCase.dart';
import '../entities/StudentCourse.dart';
import '../repositories/StudentCoursesRepository.dart';

class FetchStudentCoursesUseCase
    implements UseCase<List<StudentCourse>, String> {
  final StudentCoursesRepository repository;

  FetchStudentCoursesUseCase(this.repository);

  @override
  Future<Either<Fail, List<StudentCourse>>> execute(String studentDept) async {
    return await repository.fetchAllStudentCourses(studentDept);
  }
}
