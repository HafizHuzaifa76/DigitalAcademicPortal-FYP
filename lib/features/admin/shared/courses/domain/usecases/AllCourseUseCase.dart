import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/SemesterCourse.dart';
import '../repositories/CourseRepository.dart';

class AllCoursesUseCase implements UseCase<List<SemesterCourse>, void>{
  final CourseRepository repository;

  AllCoursesUseCase(this.repository);

  @override
  Future<Either<Fail, List<SemesterCourse>>> execute(void params) async {
    return await repository.showAllCourses();
  }
}