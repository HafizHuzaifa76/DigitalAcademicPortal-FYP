import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/StudentGradeModel.dart';

abstract class StudentGradeRemoteDataSource {
  Future<List<StudentGradeModel>> getStudentGrades(
      String studentId, String courseId);
  Future<List<StudentGradeModel>> getAllGrades(String studentId);
}

class StudentGradeRemoteDataSourceImpl implements StudentGradeRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<StudentGradeModel>> getStudentGrades(
      String studentId, String courseId) async {
    final querySnapshot = await _firestore
        .collection('grades')
        .where('studentId', isEqualTo: studentId)
        .where('courseId', isEqualTo: courseId)
        .get();

    return querySnapshot.docs
        .map((doc) => StudentGradeModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<List<StudentGradeModel>> getAllGrades(String studentId) async {
    final querySnapshot = await _firestore
        .collection('grades')
        .where('studentId', isEqualTo: studentId)
        .get();

    return querySnapshot.docs
        .map((doc) => StudentGradeModel.fromMap(doc.data()))
        .toList();
  }
}
