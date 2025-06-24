import 'package:dartz/dartz.dart';
import '../../domain/entities/Assignment.dart';
import '../../domain/repositories/TeacherAssignmentRepository.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import '../datasources/TeacherAssignmentRemoteDataSource.dart';
import '../models/AssignmentModel.dart';

class TeacherAssignmentRepositoryImpl implements TeacherAssignmentRepository {
  final TeacherAssignmentRemoteDataSource remoteDataSource;

  TeacherAssignmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Fail, List<Assignment>>> getAssignments(
      TeacherCourse course) async {
    try {
      final assignments =
          await remoteDataSource.getAssignments(course);
      return Right(assignments);
    } catch (e) {
      return Left(Fail(e));
    }
  }

  @override
  Future<Either<Fail, void>> createAssignment(
      TeacherCourse course, Assignment assignment) async {
    try {
      final assignmentModel = AssignmentModel(
        id: assignment.id,
        title: assignment.title,
        description: assignment.description,
        dueDate: assignment.dueDate,
        fileUrl: assignment.fileUrl,
      );
      await remoteDataSource.createAssignment(
          course, assignmentModel);
      return const Right(null);
    } catch (e) {
      return Left(Fail(e));
    }
  }
}
