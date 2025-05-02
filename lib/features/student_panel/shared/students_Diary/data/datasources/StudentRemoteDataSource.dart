import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/NoteModel.dart';

class NoteRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _notesRef(String dept, String rollNo) {
    return firestore
        .collection('departments')
        .doc(dept)
        .collection('students')
        .doc(rollNo)
        .collection('notes');
  }

  Stream<List<NoteModel>> getNotes(String dept, String rollNo) {
    return _notesRef(dept, rollNo).orderBy('dateTime', descending: true).snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => NoteModel.fromMap(doc.data(), doc.id))
          .toList(),
    );
  }

  Future<void> addNote(String dept, String rollNo, NoteModel note) {
    return _notesRef(dept, rollNo).doc(note.id).set(note.toMap());
  }

  Future<void> updateNote(String dept, String rollNo, NoteModel note) {
    return _notesRef(dept, rollNo).doc(note.id).update(note.toMap());
  }

  Future<void> deleteNote(String dept, String rollNo, String id) {
    return _notesRef(dept, rollNo).doc(id).delete();
  }

  Future<void> toggleCompletion(String dept, String rollNo, String id, bool status) {
    return _notesRef(dept, rollNo).doc(id).update({'isCompleted': status});
  }
}
