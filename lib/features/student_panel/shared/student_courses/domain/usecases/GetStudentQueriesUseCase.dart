import 'dart:async';
import 'package:digital_academic_portal/shared/domain/entities/Query.dart';
import '../repositories/StudentQueryRepository.dart';

class GetStudentQueriesUseCase {
  final StudentQueryRepository repository;
  GetStudentQueriesUseCase(this.repository);

  Future<List<Query>> call(
      String dept, String semester, String course, String section) {
    return repository.getQueries(dept, semester, course, section);
  }
}
