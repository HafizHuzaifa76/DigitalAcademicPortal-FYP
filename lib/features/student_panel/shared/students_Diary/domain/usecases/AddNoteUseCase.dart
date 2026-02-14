import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../repositories/StudentDiaryRepository.dart';


class AddNoteUseCase implements UseCase<void, NoteParams>{
  final StudentDiaryRepository repository;

  AddNoteUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(NoteParams params) async {
    return await repository.createNote(params.deptName, params.studentRollNo, params.note!);
  }
}