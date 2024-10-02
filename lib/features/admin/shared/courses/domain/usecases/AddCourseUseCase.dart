import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';

import '../entities/Course.dart';
import '../repositories/CourseRepository.dart';

class AddCourseUseCase implements UseCase<Course, CourseParams>{
  final CourseRepository repository;

  AddCourseUseCase(this.repository);

  @override
  Future<Either<Fail, Course>> execute(CourseParams courseParams) async {
    return await repository.addCourse(courseParams.deptName, courseParams.course);
  }
}

