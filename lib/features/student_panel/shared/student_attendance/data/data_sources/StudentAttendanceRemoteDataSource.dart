import 'package:digital_academic_portal/features/student_panel/presentation/pages/StudentPanelDashboardPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/StudentAttendanceModel.dart';

abstract class StudentAttendanceRemoteDataSource {
  Future<List<StudentAttendanceModel>> getStudentAttendance(String courseId);
  Future<List<StudentAttendanceModel>> getAllAttendance();
}

class StudentAttendanceRemoteDataSourceImpl
    implements StudentAttendanceRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var student = StudentPortalDashboardPage.studentProfile;

  @override
  Future<List<StudentAttendanceModel>> getStudentAttendance(
      String courseId) async {
    if (student == null) throw Exception('Student data not match');

    var studentId = student!.studentRollNo;
    var dept = student!.studentDepartment;

    final querySnapshot = await _firestore
        .collection('departments')
        .doc(dept)
        .collection('students')
        .doc(studentId)
        .collection('current_courses')
        .doc(courseId)
        .collection('attendance')
        .get();

    return querySnapshot.docs
        .map((doc) => StudentAttendanceModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<List<StudentAttendanceModel>> getAllAttendance() async {
    if (student == null) throw Exception('Student data not match');

    var studentId = student!.studentRollNo;
    var dept = student!.studentDepartment;

    final querySnapshot = await _firestore
        .collection('departments')
        .doc(dept)
        .collection('students')
        .doc(studentId)
        .collection('attendance')
        .get();

    return querySnapshot.docs
        .map((doc) => StudentAttendanceModel.fromMap(doc.data()))
        .toList();
  }
}
