import '../entities/note.dart';

abstract class StudentDiaryRepository {
  Stream<List<Note>> getNotes(String dept, String rollNo);
  Future<void> addNote(String dept, String rollNo, Note note);
  Future<void> updateNote(String dept, String rollNo, Note note);
  Future<void> deleteNote(String dept, String rollNo, String noteId);
  Future<void> toggleCompletion(String dept, String rollNo, String noteId, bool isCompleted);
}
