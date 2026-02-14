import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../repositories/StudentDiaryRepository.dart';


class DeleteNoteUseCase implements UseCase<void, NoteParams>{
  final StudentDiaryRepository repository;

  DeleteNoteUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(NoteParams params) async {
    return await repository.removeNote(params.deptName, params.studentRollNo, params.note!);
  }
}