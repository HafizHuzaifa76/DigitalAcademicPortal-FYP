import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../../domain/repositories/StudentDiaryRepository.dart';
import '../entities/Note.dart';

class ToggleNoteCompletionUseCase implements UseCase<Either<Fail, void>, ToggleNoteParams> {
  final StudentDiaryRepository repository;

  ToggleNoteCompletionUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(ToggleNoteParams params) {
    return repository.toggleNoteCompletion(params.dept, params.rollNo, params.noteId, params.currentStatus);
  }
}

class ToggleNoteParams {
  final String dept;
  final String rollNo;
  final String noteId;
  final bool currentStatus;

  ToggleNoteParams(this.dept, this.rollNo, this.noteId, this.currentStatus);
}
