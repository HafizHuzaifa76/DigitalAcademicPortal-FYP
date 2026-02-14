import 'package:dartz/dartz.dart';
import '../../domain/entities/Note.dart';
import '../../domain/repositories/StudentDiaryRepository.dart';
import '../../data/datasources/StudentDiaryRemoteDatasource.dart';
import 'package:digital_academic_portal/features/student_panel/shared/students_Diary/data/models/NoteModel.dart';

class StudentDiaryRepositoryImpl implements StudentDiaryRepository {
  final StudentDiaryRemoteDatasource remoteDataSource;

  StudentDiaryRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Fail, List<Note>>> getNotes(
      String deptName, String studentRollNo) async {
    try {
      final notes = await remoteDataSource.fetchNotes(deptName, studentRollNo);
      return Right(notes);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, void>> createNote(
      String deptName, String studentRollNo, Note note) async {
    try {
      await remoteDataSource.addNote(
          deptName, studentRollNo, NoteModel.fromEntity(note));
      return const Right(null);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, void>> editNote(
      String deptName, String studentRollNo, Note note) async {
    try {
      await remoteDataSource.updateNote(
          deptName, studentRollNo, NoteModel.fromEntity(note));
      return const Right(null);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, void>> removeNote(
      String deptName, String studentRollNo, Note note) async {
    try {
      await remoteDataSource.deleteNote(deptName, studentRollNo, note.id);
      return const Right(null);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }
}
