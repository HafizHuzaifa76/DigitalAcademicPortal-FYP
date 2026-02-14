import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/courses/domain/entities/DepartmentCourse.dart';
import '../repositories/CourseRepository.dart';

class DeptCoursesUseCase implements UseCase<List<DepartmentCourse>, String>{
  final CourseRepository repository;

  DeptCoursesUseCase(this.repository);

  @override
  Future<Either<Fail, List<DepartmentCourse>>> execute(String deptName) async {
    return await repository.showDeptCourses(deptName);
  }
}