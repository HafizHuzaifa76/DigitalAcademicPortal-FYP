import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/courses/domain/entities/DepartmentCourse.dart';

import '../repositories/CourseRepository.dart';

class AddCourseUseCase implements UseCase<DepartmentCourse, CourseParams>{
  final CourseRepository repository;

  AddCourseUseCase(this.repository);

  @override
  Future<Either<Fail, DepartmentCourse>> execute(CourseParams courseParams) async {
    return await repository.addCourse(courseParams.deptName, courseParams.course);
  }
}

class AddCourseListUseCase implements UseCase<void, List<DepartmentCourse>>{
  final CourseRepository repository;

  AddCourseListUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(List<DepartmentCourse> courses) async {
    return await repository.addCourseList(courses);
  }
}

