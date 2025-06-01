import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/PreviousCourseGrade.dart';
import '../repositories/PreviousCourseGradeRepository.dart';

class GetPreviousCourseGradesParams {
  final String studentId;

  GetPreviousCourseGradesParams({required this.studentId});
}

class GetPreviousCourseGradesUseCase
    implements
        UseCase<List<PreviousCourseGrade>, GetPreviousCourseGradesParams> {
  final PreviousCourseGradeRepository repository;

  GetPreviousCourseGradesUseCase(this.repository);

  @override
  Future<Either<Fail, List<PreviousCourseGrade>>> execute(
      GetPreviousCourseGradesParams params) async {
    return await repository.getPreviousCourseGrades(params.studentId);
  }
}
