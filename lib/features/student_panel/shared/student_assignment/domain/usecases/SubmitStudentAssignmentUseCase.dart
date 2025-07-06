import 'package:dartz/dartz.dart';
import '../repositories/StudentAssignmentRepository.dart';
import '../../../../../../core/usecases/UseCase.dart';

class SubmitStudentAssignmentUseCase
    implements UseCase<void, SubmitAssignmentParams> {
  final StudentAssignmentRepository repository;
  SubmitStudentAssignmentUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(SubmitAssignmentParams params) async {
    return await repository.submitAssignment(
        params.assignmentId, params.fileUrl);
  }
}

class SubmitAssignmentParams {
  final String assignmentId;
  final String fileUrl;
  SubmitAssignmentParams({required this.assignmentId, required this.fileUrl});
}
