import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../repositories/StudentDiaryRepository.dart';

class EditNoteUseCase implements UseCase<void, NoteParams>{
  final StudentDiaryRepository repository;

  EditNoteUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(NoteParams params) async {
    return await repository.editNote(params.deptName, params.studentRollNo, params.note!);
  }
}