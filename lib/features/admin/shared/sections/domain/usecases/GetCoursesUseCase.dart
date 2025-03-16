
import 'package:dartz/dartz.dart';

import '../../../../../../core/usecases/UseCase.dart';
import '../../../courses/domain/entities/SemesterCourse.dart';
import '../../../courses/domain/usecases/SemesterCoursesUseCase.dart';

class GetCoursesUseCase implements UseCase<List<SemesterCourse>, SemesterParams>{
  final SemesterCoursesUseCase useCase;

  GetCoursesUseCase(this.useCase);

  @override
  Future<Either<Fail, List<SemesterCourse>>> execute(SemesterParams semesterParams) async {
    return await useCase.execute(semesterParams);
  }
}