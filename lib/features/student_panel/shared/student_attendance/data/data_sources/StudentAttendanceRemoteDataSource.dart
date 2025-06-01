import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/StudentAttendanceModel.dart';

abstract class StudentAttendanceRemoteDataSource {
  Future<List<StudentAttendanceModel>> getStudentAttendance(String studentId, String courseId);
  Future<List<StudentAttendanceModel>> getAllAttendance(String studentId);
}

class StudentAttendanceRemoteDataSourceImpl implements StudentAttendanceRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<StudentAttendanceModel>> getStudentAttendance(String studentId, String courseId) async {
    final querySnapshot = await _firestore
        .collection('attendance')
        .where('studentId', isEqualTo: studentId)
        .where('courseId', isEqualTo: courseId)
        .get();
    
    return querySnapshot.docs
        .map((doc) => StudentAttendanceModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<List<StudentAttendanceModel>> getAllAttendance(String studentId) async {
    final querySnapshot = await _firestore
        .collection('attendance')
        .where('studentId', isEqualTo: studentId)
        .get();
    
    return querySnapshot.docs
        .map((doc) => StudentAttendanceModel.fromMap(doc.data()))
        .toList();
  }
}