import 'package:get/get.dart';
import '../../data/repositories/StudentDiaryRepositoryImpl.dart' show NoteRepositoryImpl;
import '../../domain/entities/note.dart';

class NoteController extends GetxController {
  final notes = <Note>[].obs;
  final dept = ''.obs;
  final rollNo = ''.obs;

  final repo = NoteRepositoryImpl();

  void init(String department, String rollNumber) {
    dept.value = department;
    rollNo.value = rollNumber;
    repo.getNotes(dept.value, rollNo.value).listen((data) {
      notes.assignAll(data);
    });
  }

  Future<void> addNote(Note note) => repo.addNote(dept.value, rollNo.value, note);
  Future<void> updateNote(Note note) => repo.updateNote(dept.value, rollNo.value, note);
  Future<void> deleteNote(String id) => repo.deleteNote(dept.value, rollNo.value, id);
  Future<void> toggleCompletion(String id, bool current) => repo.toggleCompletion(dept.value, rollNo.value, id, !current);
}
