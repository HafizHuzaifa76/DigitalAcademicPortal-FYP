import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../repositories/CourseRepository.dart';

class DeleteCourseUseCase implements UseCase<void, CourseParams>{
  final CourseRepository repository;

  DeleteCourseUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(CourseParams courseParams) async {
    return await repository.deleteCourse(courseParams.deptName, courseParams.course);
  }
}