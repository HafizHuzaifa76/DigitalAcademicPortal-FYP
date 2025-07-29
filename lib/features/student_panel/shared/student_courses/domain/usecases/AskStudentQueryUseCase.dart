import 'dart:async';
import 'package:digital_academic_portal/shared/domain/entities/Query.dart';
import '../repositories/StudentQueryRepository.dart';

class AskStudentQueryUseCase {
  final StudentQueryRepository repository;
  AskStudentQueryUseCase(this.repository);

  Future<void> call(Query query, String dept, String semester, String course, String section) {
    return repository.addQuery(query, dept, semester, course, section);
  }
}
