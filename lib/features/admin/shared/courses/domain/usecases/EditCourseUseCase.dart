
import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import 'package:digital_academic_portal/features/admin/shared/courses/domain/entities/DepartmentCourse.dart';
import '../repositories/CourseRepository.dart';

class EditCourseUseCase implements UseCase<DepartmentCourse, CourseParams>{
  final CourseRepository repository;

  EditCourseUseCase(this.repository);

  @override
  Future<Either<Fail, DepartmentCourse>> execute(CourseParams courseParams) async {
    return await repository.editCourse(courseParams.deptName, courseParams.course);
  }
}