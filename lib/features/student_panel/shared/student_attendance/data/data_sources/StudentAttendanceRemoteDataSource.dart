import 'package:digital_academic_portal/features/student_panel/presentation/pages/StudentDashboardPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../shared/data/models/AttendanceModel.dart';

abstract class StudentAttendanceRemoteDataSource {
  Future<List<AttendanceModel>> getStudentAttendance(String courseId);
  Future<List<AttendanceModel>> getAllAttendance();
}

class StudentAttendanceRemoteDataSourceImpl
    implements StudentAttendanceRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var student = StudentDashboardPage.studentProfile;

  @override
  Future<List<AttendanceModel>> getStudentAttendance(String courseId) async {
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
        .map((doc) => AttendanceModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<List<AttendanceModel>> getAllAttendance() async {
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
        .map((doc) => AttendanceModel.fromMap(doc.data()))
        .toList();
  }
}
