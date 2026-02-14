import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_academic_portal/features/student_panel/shared/students_Diary/data/models/NoteModel.dart';

abstract class StudentDiaryRemoteDatasource {
  Future<List<NoteModel>> fetchNotes(String deptName, String studentRollNo);
  Future<void> addNote(String deptName, String studentRollNo, NoteModel note);
  Future<void> updateNote(String deptName, String studentRollNo, NoteModel note);
  Future<void> deleteNote(String deptName, String studentRollNo, String noteId);
}

class StudentDiaryRemoteDatasourceImpl implements StudentDiaryRemoteDatasource {
  
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<NoteModel>> fetchNotes(String deptName, String studentRollNo) async {
    final snapshot = await firestore
        .collection('departments')
        .doc(deptName)
        .collection('students')
        .doc(studentRollNo)
        .collection('notes')
        .get();

    return snapshot.docs.map((doc) => NoteModel.fromJson(doc.data(), doc.id)).toList();
  }

  @override
  Future<void> addNote(String deptName, String studentRollNo, NoteModel note) async {
    await firestore
        .collection('departments')
        .doc(deptName)
        .collection('students')
        .doc(studentRollNo)
        .collection('notes')
        .add(note.toJson());
  }

  @override
  Future<void> updateNote(String deptName, String studentRollNo, NoteModel note) async {
    await firestore
        .collection('departments')
        .doc(deptName)
        .collection('students')
        .doc(studentRollNo)
        .collection('notes')
        .doc(note.id)
        .update(note.toJson());
  }

  @override
  Future<void> deleteNote(String deptName, String studentRollNo, String noteId) async {
    await firestore
        .collection('departments')
        .doc(deptName)
        .collection('students')
        .doc(studentRollNo)
        .collection('notes')
        .doc(noteId)
        .delete();
  }
}