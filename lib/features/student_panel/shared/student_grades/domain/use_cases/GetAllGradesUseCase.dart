import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/StudentGrade.dart';
import '../repositories/StudentGradeRepository.dart';

class GetAllGradesParams {
  final String studentId;

  GetAllGradesParams({required this.studentId});
}

class GetAllGradesUseCase
    implements UseCase<List<StudentGrade>, GetAllGradesParams> {
  final StudentGradeRepository repository;

  GetAllGradesUseCase(this.repository);

  @override
  Future<Either<Fail, List<StudentGrade>>> execute(
      GetAllGradesParams params) async {
    return await repository.getAllGrades(params.studentId);
  }
}
