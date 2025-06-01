import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/core/usecases/UseCase.dart';
import '../entities/Note.dart';
import '../repositories/StudentDiaryRepository.dart';

class AllNotesUseCase implements UseCase<List<Note>, NoteParams> {
  final StudentDiaryRepository repository;

  AllNotesUseCase(this.repository);

  @override
  Future<Either<Fail, List<Note>>> execute(NoteParams params) async {
    return await repository.getNotes(params.deptName, params.studentRollNo);
  }
}
