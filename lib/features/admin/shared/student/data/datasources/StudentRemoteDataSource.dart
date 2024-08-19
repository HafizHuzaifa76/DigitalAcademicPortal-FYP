
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/StudentModel.dart';

abstract class StudentRemoteDataSource{
  Future<StudentModel> addStudent(StudentModel student);
  Future<StudentModel> editStudent(StudentModel student);
  Future<void> deleteStudent(String studentID);
  Future<List<StudentModel>> allStudents();
}

class StudentRemoteDataSourceImpl implements StudentRemoteDataSource{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<StudentModel> addStudent(StudentModel student) async {
    var ref = _firestore.collection('students').doc(student.studentEmail);
    var snapshot = await ref.get();

    if (!snapshot.exists) {
      await ref.set(student.toMap());
    } else {
      throw Exception('Student already exists');
    }

    return student;
  }

  @override
  Future<void> deleteStudent(String id) async {
    _firestore.collection('students').doc(id).delete();
  }

  @override
  Future<StudentModel> editStudent(StudentModel student) async {
    var ref = _firestore.collection('students').doc(student.studentEmail);
    var snapshot = await ref.get();

    if (snapshot.exists) {
      await ref.set(student.toMap());
    } else {
      throw Exception('Student not exists');
    }

    return student;
  }

  @override
  Future<List<StudentModel>> allStudents() async {
    final querySnapshot = await _firestore.collection('students').get();
    return querySnapshot.docs
        .map((doc) => StudentModel.fromMap(doc.data()))
        .toList();
  }

}