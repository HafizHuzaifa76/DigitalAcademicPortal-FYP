import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/SemesterCourse.dart';
import '../repositories/CourseRepository.dart';

class SemesterCoursesUseCase implements UseCase<List<SemesterCourse>, SemesterParams>{
  final CourseRepository repository;

  SemesterCoursesUseCase(this.repository);

  @override
  Future<Either<Fail, List<SemesterCourse>>> execute(SemesterParams semesterParams) async {
    return await repository.showSemesterCourses(semesterParams.deptName, semesterParams.semester);
  }
}