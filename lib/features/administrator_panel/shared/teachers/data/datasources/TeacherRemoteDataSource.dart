
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_academic_portal/shared/domain/entities/Teacher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../../shared/data/models/TeacherModel.dart';

abstract class TeacherRemoteDataSource{
  Future<TeacherModel> addTeacher(TeacherModel teacher);
  Future<String> addTeachersList(List<Teacher> teachersList);
  Future<TeacherModel> editTeacher(TeacherModel teacher);
  Future<void> deleteTeacher(TeacherModel teacher);
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
          .collection('departments').doc(teacher.teacherDept)
          .collection('teachers')
          .where('teacherEmail', isEqualTo: teacher.teacherEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw Exception('Teacher with this email already exists');
      }

      querySnapshot = await _firestore
          .collection('departments').doc(teacher.teacherDept)
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

      final String displayName = 'teacher | ${teacher.teacherDept} | ${teacher.teacherName}';
      await userCredential.user!.updateDisplayName(displayName);

      var ref = _firestore.collection('departments').doc(teacher.teacherDept)
          .collection('teachers').doc(teacher.teacherCNIC);
      await ref.set(teacher.toMap());

      return teacher;
    } catch (e) {
      throw Exception('Error adding teacher: $e');
    }
  }

  @override
  Future<void> deleteTeacher(TeacherModel teacher) async {
    _firestore.collection('departments').doc(teacher.teacherDept)
          .collection('teachers').doc(teacher.teacherCNIC).delete();
  }

  @override
  Future<TeacherModel> editTeacher(TeacherModel teacher) async {
    var ref = _firestore.collection('teacher').doc(teacher.teacherCNIC);
    var snapshot = await ref.get();

    if (snapshot.exists) {
      await ref.set(teacher.toMap());
    } else {
      throw Exception('Teacher not exists');
    }

    return teacher;
  }

  @override
  Future<String> addTeachersList(List<Teacher> teachersList) async {
    int chunkSize = 20;
    String deptName = teachersList.first.teacherDept;
    String message = '';
    var ref = _firestore.collection('departments').doc(deptName);

    // Split the list into chunks of the specified size
    List<List<Teacher>> chunks = [];
    for (var i = 0; i < teachersList.length; i += chunkSize) {
      chunks.add(teachersList.sublist(i, i + chunkSize > teachersList.length ? teachersList.length : i + chunkSize));
    }

    for (var chunk in chunks) {
      await Future.wait(chunk.map((teacher) async {

        QuerySnapshot querySnapshot1 = await ref.collection('teachers')
            .where('teacherEmail', isEqualTo: teacher.teacherEmail).get();

        QuerySnapshot querySnapshot2 = await ref.collection('teachers')
            .where('teacherCNIC', isEqualTo: teacher.teacherCNIC).get();

        var teacherRef = ref.collection('teachers').doc(teacher.teacherCNIC);

        if (querySnapshot1.docs.isEmpty && querySnapshot2.docs.isEmpty) {
          await _auth.createUserWithEmailAndPassword(
            email: teacher.teacherEmail,
            password: teacher.teacherCNIC,
          );
          await teacherRef.set(TeacherModel.fromTeacher(teacher).toMap());
        } else {
          if (kDebugMode) {
            print('Teacher ${teacher.teacherName} ${teacher.teacherCNIC} already exists, skipping...');
          }
          message = '${message}Teacher ${teacher.teacherName} ${teacher.teacherCNIC} already exists, skipping...\n';
        }
      }));
    }

    return message.isNotEmpty ? message : 'All teachers added successfully...';
  }

  @override
  Future<List<TeacherModel>> allTeachers() async {
    final querySnapshot = await _firestore.collection('departments').get();
    List<TeacherModel> teachersList = [];

    for (var departmentDoc in querySnapshot.docs) {
      final teachersQuerySnapshot = await _firestore.collection('departments')
          .doc(departmentDoc.id)
          .collection('teachers')
          .get();

      for (var teacherDoc in teachersQuerySnapshot.docs) {
        teachersList.add(TeacherModel.fromMap(teacherDoc.data()));
      }
    }

    return teachersList;
  }

  @override
  Future<List<TeacherModel>> getTeachersByDepartment(String deptName) async {
    final querySnapshot = await _firestore.collection('departments').doc(deptName).collection('teachers')
        .get();

    return querySnapshot.docs
        .map((doc) => TeacherModel.fromMap(doc.data()))
        .toList();
  }
}