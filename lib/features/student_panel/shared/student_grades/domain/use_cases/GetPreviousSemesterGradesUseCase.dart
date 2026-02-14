import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../../../../../../shared/domain/entities/PreviousCourseGrade.dart';
import '../repositories/PreviousCourseGradeRepository.dart';

class GetPreviousSemesterGradesParams {
  final String studentId;
  final String semester;

  GetPreviousSemesterGradesParams({
    required this.studentId,
    required this.semester,
  });
}

class GetPreviousSemesterGradesUseCase
    implements
        UseCase<List<PreviousCourseGrade>, GetPreviousSemesterGradesParams> {
  final PreviousCourseGradeRepository repository;

  GetPreviousSemesterGradesUseCase(this.repository);

  @override
  Future<Either<Fail, List<PreviousCourseGrade>>> execute(
      GetPreviousSemesterGradesParams params) async {
    return await repository.getPreviousSemesterGrades(
        params.studentId, params.semester);
  }
}
