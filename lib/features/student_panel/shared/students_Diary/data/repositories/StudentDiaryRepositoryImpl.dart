import '../../domain/entities/note.dart';
import '../../domain/repositories/StudentDiaryRepository.dart';
import '../datasources/StudentRemoteDataSource.dart';
import '../models/NoteModel.dart';

class NoteRepositoryImpl implements StudentDiaryRepository {
  final NoteRemoteDataSource dataSource = NoteRemoteDataSource();

  @override
  Stream<List<Note>> getNotes(String dept, String rollNo) {
    return dataSource.getNotes(dept, rollNo);
  }

  @override
  Future<void> addNote(String dept, String rollNo, Note note) {
    return dataSource.addNote(dept, rollNo, NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      isCompleted: note.isCompleted,
      dateTime: note.dateTime,
    ));
  }

  @override
  Future<void> updateNote(String dept, String rollNo, Note note) {
    return dataSource.updateNote(dept, rollNo, NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      isCompleted: note.isCompleted,
      dateTime: note.dateTime,
    ));
  }

  @override
  Future<void> deleteNote(String dept, String rollNo, String noteId) {
    return dataSource.deleteNote(dept, rollNo, noteId);
  }

  @override
  Future<void> toggleCompletion(String dept, String rollNo, String noteId, bool isCompleted) {
    return dataSource.toggleCompletion(dept, rollNo, noteId, isCompleted);
  }
}
