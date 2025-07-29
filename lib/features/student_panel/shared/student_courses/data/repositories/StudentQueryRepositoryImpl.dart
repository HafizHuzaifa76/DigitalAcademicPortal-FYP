import 'dart:async';
import 'package:digital_academic_portal/shared/domain/entities/Query.dart';
import '../../domain/repositories/StudentQueryRepository.dart';
import '../datasources/StudentQueryRemoteDataSource.dart';
import '../models/StudentQueryModel.dart';

class StudentQueryRepositoryImpl implements StudentQueryRepository {
  final StudentQueryRemoteDataSource remoteDataSource;
  StudentQueryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Query>> getQueries(
      String dept, String semester, String course, String section) {
    return remoteDataSource.getQueries(dept, semester, course, section);
  }

  @override
  Future<void> addQuery(Query query, String dept, String semester,
      String course, String section) {
    return remoteDataSource.addQuery(StudentQueryModel.fromEntity(query), dept, semester, course, section);
  }
}
