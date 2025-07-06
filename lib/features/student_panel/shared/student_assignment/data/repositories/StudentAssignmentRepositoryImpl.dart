import 'package:dartz/dartz.dart';
import '../../domain/entities/StudentAssignment.dart';
import '../../../student_courses/domain/entities/StudentCourse.dart';
import '../../domain/repositories/StudentAssignmentRepository.dart';
import '../datasources/StudentAssignmentRemoteDataSource.dart';
import '../models/StudentAssignmentModel.dart';
import '../../../../../../core/usecases/UseCase.dart';

class StudentAssignmentRepositoryImpl implements StudentAssignmentRepository {
  final StudentAssignmentRemoteDataSource remoteDataSource;
  StudentAssignmentRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Fail, List<StudentAssignment>>> getAssignments(
      StudentCourse course) async {
    try {
      final assignments = await remoteDataSource.getAssignments(course);
      return Right(assignments);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, void>> submitAssignment(
      String assignmentId, String fileUrl) async {
    try {
      await remoteDataSource.submitAssignment(assignmentId, fileUrl);
      return const Right(null);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }
}
