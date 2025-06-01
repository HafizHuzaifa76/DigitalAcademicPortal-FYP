import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/TeacherAttendance.dart';
import '../models/TeacherAttendanceModel.dart';

abstract class TeacherAttendanceRemoteDataSource {
  Future<List<TeacherAttendanceModel>> getAttendanceForDate(
      String courseId, String courseSection, DateTime date);
  Future<void> markAttendance(List<TeacherAttendanceModel> attendanceList);
}

class TeacherAttendanceRemoteDataSourceImpl
    implements TeacherAttendanceRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<List<TeacherAttendanceModel>> getAttendanceForDate(
      String courseId, String courseSection, DateTime date) async {
    try {
      final QuerySnapshot attendanceSnapshot = await _firestore
          .collection('departments')
          .doc(courseId.split('-')[0]) // e.g., BSCS from BSCS-6A
          .collection('courses')
          .doc(courseId)
          .collection('sections')
          .doc(courseSection)
          .collection('attendance')
          .where('date', isEqualTo: date.toIso8601String().split('T')[0])
          .get();

      return attendanceSnapshot.docs
          .map((doc) => TeacherAttendanceModel.fromMap(
              doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch attendance: ${e.toString()}');
    }
  }

  @override
  Future<void> markAttendance(
      List<TeacherAttendanceModel> attendanceList) async {
    try {
      final batch = _firestore.batch();

      for (var attendance in attendanceList) {
        final docRef = _firestore
            .collection('departments')
            .doc(attendance.courseId.split('-')[0])
            .collection('courses')
            .doc(attendance.courseId)
            .collection('sections')
            .doc(attendance.courseSection)
            .collection('attendance')
            .doc(
                '${attendance.date.toIso8601String().split('T')[0]}_${attendance.studentId}');

        batch.set(docRef, attendance.toMap());
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to mark attendance: ${e.toString()}');
    }
  }
}
