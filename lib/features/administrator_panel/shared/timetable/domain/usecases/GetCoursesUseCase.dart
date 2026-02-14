
import 'package:dartz/dartz.dart';

import '../../../../../../core/usecases/UseCase.dart';
import '../../../../../../shared/domain/entities/SemesterCourse.dart';
import '../../../courses/domain/usecases/SemesterCoursesUseCase.dart';

class GetTimeTableCoursesUseCase implements UseCase<List<SemesterCourse>, SemesterParams>{
  final SemesterCoursesUseCase useCase;

  GetTimeTableCoursesUseCase(this.useCase);

  @override
  Future<Either<Fail, List<SemesterCourse>>> execute(SemesterParams semesterParams) async {
    return await useCase.execute(semesterParams);
  }
}