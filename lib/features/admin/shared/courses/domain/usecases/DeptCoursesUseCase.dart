import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/Course.dart';
import '../repositories/CourseRepository.dart';

class DeptCoursesUseCase implements UseCase<List<Course>, String>{
  final CourseRepository repository;

  DeptCoursesUseCase(this.repository);

  @override
  Future<Either<Fail, List<Course>>> execute(String deptName) async {
    return await repository.showDeptCourses(deptName);
  }
}