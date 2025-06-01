import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/PreviousCourseGradeModel.dart';

abstract class PreviousCourseGradeRemoteDataSource {
  Future<List<PreviousCourseGradeModel>> getPreviousCourseGrades(
      String studentId);
  Future<List<PreviousCourseGradeModel>> getPreviousSemesterGrades(
      String studentId, String semester);
}

class PreviousCourseGradeRemoteDataSourceImpl
    implements PreviousCourseGradeRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<PreviousCourseGradeModel>> getPreviousCourseGrades(
      String studentId) async {
    final querySnapshot = await _firestore
        .collection('previous_grades')
        .where('studentId', isEqualTo: studentId)
        .get();

    return querySnapshot.docs
        .map((doc) => PreviousCourseGradeModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<List<PreviousCourseGradeModel>> getPreviousSemesterGrades(
      String studentId, String semester) async {
    final querySnapshot = await _firestore
        .collection('previous_grades')
        .where('studentId', isEqualTo: studentId)
        .where('semester', isEqualTo: semester)
        .get();

    return querySnapshot.docs
        .map((doc) => PreviousCourseGradeModel.fromMap(doc.data()))
        .toList();
  }
}
