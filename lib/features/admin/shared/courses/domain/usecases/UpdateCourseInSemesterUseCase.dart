import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import 'package:digital_academic_portal/features/admin/shared/departments/data/models/SemesterModel.dart';
import '../../../departments/domain/usecases/UpdateSemesterCoursesUseCase.dart';
import '../entities/SemesterCourse.dart';
import '../repositories/CourseRepository.dart';

class UpdateCourseInSemesterUseCase implements UseCase<SemesterModel, UpdateSemesterParams>{
  final UpdateSemesterCourseUseCase useCase;

  UpdateCourseInSemesterUseCase(this.useCase);

  @override
  Future<Either<Fail, SemesterModel>> execute(UpdateSemesterParams semesterParams) async {
    return await useCase.execute(semesterParams);
  }
}