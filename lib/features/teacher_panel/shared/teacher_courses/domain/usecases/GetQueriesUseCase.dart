import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../../../../../../shared/domain/entities/Query.dart';
import '../entities/TeacherCourse.dart';
import '../repositories/TeacherCourseRepository.dart';

class GetQueriesUseCase implements UseCase<List<Query>, TeacherCourse> {
  final TeacherCourseRepository repository;

  GetQueriesUseCase(this.repository);

  @override
  Future<Either<Fail, List<Query>>> execute(TeacherCourse course) async {
    return await repository.getQueries(course);
  }
}
