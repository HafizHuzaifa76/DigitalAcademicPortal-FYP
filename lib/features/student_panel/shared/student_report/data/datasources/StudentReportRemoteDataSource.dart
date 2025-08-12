import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/StudentReportModel.dart';

abstract class StudentReportRemoteDataSource {
  Future<void> submitReport(StudentReportModel report);
  Future<List<StudentReportModel>> getReportsForStudent(String studentRollNo);
}

class StudentReportRemoteDataSourceImpl
    implements StudentReportRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> submitReport(StudentReportModel report) async {
    await _firestore
        .collection('reports')
        .doc('report')
        .collection('items')
        .doc(report.id)
        .set(report.toMap());
  }

  @override
  Future<List<StudentReportModel>> getReportsForStudent(
      String studentRollNo) async {
    final querySnapshot = await _firestore
        .collection('reports')
        .doc('report')
        .collection('items')
        .where('studentRollNo', isEqualTo: studentRollNo)
        .get();
    return querySnapshot.docs
        .map((doc) => StudentReportModel.fromMap(doc.data()))
        .toList();
  }
}
