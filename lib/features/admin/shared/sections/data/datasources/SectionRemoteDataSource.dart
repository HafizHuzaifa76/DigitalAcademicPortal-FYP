
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/SectionModel.dart';

abstract class SectionRemoteDataSource{
  Future<SectionModel> addSection(String deptName, String semester, SectionModel section);
  Future<SectionModel> editSection(String deptName, String semester, SectionModel section);
  Future<void> deleteSection(String deptName, String semester, String sectionName);
  Future<void> enrollStudentListInSection(String deptName, String semester, String sectionName, List<String> studentList);
  Future<List<SectionModel>> allSections(String deptName, String semester);
}

class SectionRemoteDataSourceImpl implements SectionRemoteDataSource{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<SectionModel> addSection(String deptName, String semester, SectionModel section) async {
    var courseRef = _firestore.collection('departments').doc(deptName).collection('semesters').doc(semester);
    var ref = courseRef.collection('sections').doc(section.sectionID);
    var snapshot = await ref.get();

    if (!snapshot.exists) {
      await ref.set(section.toMap());
    } else {
      throw Exception('Section already exists');
    }

    return section;
  }

  @override
  Future<void> deleteSection(String deptName, String semester, String sectionID) async {
    var courseRef = _firestore.collection('departments').doc(deptName).collection('semesters').doc(semester);
    courseRef.collection('sections').doc(sectionID).delete();
  }

  @override
  Future<SectionModel> editSection(String deptName, String semester, SectionModel section) async {
    var courseRef = _firestore.collection('departments').doc(deptName).collection('semesters').doc(semester);
    var ref = courseRef.collection('sections').doc(section.sectionID);
    var snapshot = await ref.get();

    if (snapshot.exists) {
      await ref.set(section.toMap());
    } else {
      throw Exception('Section not exists');
    }

    return section;
  }

  @override
  Future<List<SectionModel>> allSections(String deptName, String semester) async {
    var courseRef = _firestore.collection('departments').doc(deptName).collection('semesters').doc(semester);
    final querySnapshot = await courseRef.collection('sections').get();
    return querySnapshot.docs
        .map((doc) => SectionModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<void> enrollStudentListInSection(String deptName, String semester, String sectionName, List<String> studentList) async {
    var ref = _firestore.collection('departments').doc(deptName).collection('semesters').doc(semester)
        .collection('sections').doc(sectionName);

    await ref.set({
      'studentsList': studentList
    });
  }

}