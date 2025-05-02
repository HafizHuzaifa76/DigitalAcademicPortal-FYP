import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../../domain/repositories/StudentDiaryRepository.dart';
import '../entities/Note.dart';

class GetAllNotesUseCase implements UseCase<Either<Fail, List<Note>>, GetNotesParams> {
  final StudentDiaryRepository repository;

  GetAllNotesUseCase(this.repository);

  @override
  Future<Either<Fail, List<Note>>> execute(GetNotesParams params) {
    return repository.getAllNotes(params.dept, params.rollNo);
  }
}

class GetNotesParams {
  final String dept;
  final String rollNo;

  GetNotesParams(this.dept, this.rollNo);
}

class AddNoteUseCase implements UseCase<Either<Fail, void>, AddNoteParams> {
  final StudentDiaryRepository repository;

  AddNoteUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(AddNoteParams params) {
    return repository.addNote(params.dept, params.rollNo, params.note);
  }
}

class AddNoteParams {
  final String dept;
  final String rollNo;
  final Note note;

  AddNoteParams(this.dept, this.rollNo, this.note);
}

class UpdateNoteUseCase implements UseCase<Either<Fail, void>, UpdateNoteParams> {
  final StudentDiaryRepository repository;

  UpdateNoteUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(UpdateNoteParams params) {
    return repository.updateNote(params.dept, params.rollNo, params.note);
  }
}

class UpdateNoteParams {
  final String dept;
  final String rollNo;
  final Note note;

  UpdateNoteParams(this.dept, this.rollNo, this.note);
}

class DeleteNoteUseCase implements UseCase<Either<Fail, void>, DeleteNoteParams> {
  final StudentDiaryRepository repository;

  DeleteNoteUseCase(this.repository);

  @override
  Future<Either<Fail, void>> execute(DeleteNoteParams params) {
    return repository.deleteNote(params.dept, params.rollNo, params.noteId);
  }
}

class DeleteNoteParams {
  final String dept;
  final String rollNo;
  final String noteId;

  DeleteNoteParams(this.dept, this.rollNo, this.noteId);
}
