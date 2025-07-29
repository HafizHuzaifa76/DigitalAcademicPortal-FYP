import 'dart:async';
import 'package:digital_academic_portal/shared/domain/entities/Query.dart';

abstract class StudentQueryRepository {
  Future<List<Query>> getQueries(
      String dept, String semester, String course, String section);
  Future<void> addQuery(
      Query query, String dept, String semester, String course, String section);
}
