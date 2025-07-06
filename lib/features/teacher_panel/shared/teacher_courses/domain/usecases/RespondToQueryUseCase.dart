import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/TeacherCourse.dart';
import '../repositories/TeacherCourseRepository.dart';

class RespondToQueryParams {
  final String queryId;
  final String response;
  final TeacherCourse course;

  RespondToQueryParams({
    required this.queryId,
    required this.response,
    required this.course,
  });
}

class RespondToQueryUseCase implements UseCase<void, RespondToQueryParams> {
  final TeacherCourseRepository repository;

  RespondToQueryUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(RespondToQueryParams params) async {
    return await repository.respondToQuery(params.queryId, params.response, params.course);
  }
}
