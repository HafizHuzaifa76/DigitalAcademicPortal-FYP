
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/TeacherModel.dart';

abstract class TeacherRemoteDataSource{
  Future<TeacherModel> addTeacher(TeacherModel department);
  Future<TeacherModel> editTeacher(TeacherModel department);
  Future<void> deleteTeacher(String departmentName);
  Future<List<TeacherModel>> allTeachers();
  Future<List<TeacherModel>> getTeachersByDepartment(String deptName);
}

class TeacherRemoteDataSourceImpl implements TeacherRemoteDataSource{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<TeacherModel> addTeacher(TeacherModel teacher) async {
    try {

      QuerySnapshot querySnapshot = await _firestore
          .collection('teachers')
          .where('teacherEmail', isEqualTo: teacher.teacherEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw Exception('Teacher with this email already exists');
      }

      querySnapshot = await _firestore
          .collection('teachers')
          .where('teacherCNIC', isEqualTo: teacher.teacherCNIC)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw Exception('Teacher with this CNIC already exists');
      }

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: teacher.teacherEmail,
        password: teacher.teacherCNIC,
      );

      String uid = userCredential.user!.uid;

      var ref = _firestore.collection('teachers').doc(uid);
      await ref.set(teacher.toMap());

      return teacher;
    } catch (e) {
      throw Exception('Error adding teacher: $e');
    }
  }

  @override
  Future<void> deleteTeacher(String id) async {
    _firestore.collection('teachers').doc(id).delete();
  }

  @override
  Future<TeacherModel> editTeacher(TeacherModel teacher) async {
    var ref = _firestore.collection('teacher').doc(teacher.teacherEmail);
    var snapshot = await ref.get();

    if (snapshot.exists) {
      await ref.set(teacher.toMap());
    } else {
      throw Exception('Teacher not exists');
    }

    return teacher;
  }

  @override
  Future<List<TeacherModel>> allTeachers() async {
    final querySnapshot = await _firestore.collection('teachers').get();
    return querySnapshot.docs
        .map((doc) => TeacherModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<List<TeacherModel>> getTeachersByDepartment(String deptName) async {
    final querySnapshot = await _firestore.collection('teachers')
        .where('teacherDept', isEqualTo: deptName)
        .get();

    return querySnapshot.docs
        .map((doc) => TeacherModel.fromMap(doc.data()))
        .toList();
  }
}