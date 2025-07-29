import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../presentation/pages/StudentPanelDashboardPage.dart';
import '../models/StudentQueryModel.dart';
import 'package:digital_academic_portal/shared/domain/entities/Query.dart'
    as student_query_entity;

abstract class StudentQueryRemoteDataSource {
  Future<List<StudentQueryModel>> getQueries(
      String dept, String semester, String course, String section);
  Future<void> addQuery(StudentQueryModel query, String dept,
      String semester, String course, String section);
}

class StudentQueryRemoteDataSourceImpl implements StudentQueryRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final student = StudentPortalDashboardPage.studentProfile;

  @override
  Future<List<StudentQueryModel>> getQueries(
      String dept, String semester, String course, String section) async {

    if (student == null) throw Exception('Student data not found');
    final studentID = student?.studentRollNo;
    final snapshot = await firestore
        .collection('departments')
        .doc(dept)
        .collection('semesters')
        .doc(semester)
        .collection('courses')
        .doc(course)
        .collection('sections')
        .doc(section)
        .collection('queries')
        .where('studentID', isEqualTo: studentID)
        .get();

    return snapshot.docs
        .map((doc) => StudentQueryModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<void> addQuery(StudentQueryModel query, String dept,
      String semester, String course, String section) async {

    await firestore
        .collection('departments')
        .doc(dept)
        .collection('semesters')
        .doc(semester)
        .collection('courses')
        .doc(course)
        .collection('sections')
        .doc(section)
        .collection('queries')
        .doc(query.id)
        .set(query.toMap());
  }
}
