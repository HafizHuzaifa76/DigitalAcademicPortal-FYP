import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_academic_portal/features/teacher_panel/presentation/pages/TeacherDashboardPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../../shared/domain/entities/Attendance.dart';
import '../../../../../../shared/data/models/AttendanceModel.dart';

abstract class TeacherAttendanceRemoteDataSource {
  Future<Map<String, List<AttendanceModel>>> getCourseAttendance(
      String semester, String section, String courseId);
  Future<void> markAttendance(
      String semester, String section, List<AttendanceModel> attendanceList);
}

class TeacherAttendanceRemoteDataSourceImpl
    implements TeacherAttendanceRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final teacher = TeacherDashboardPage.teacherProfile;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<Map<String, List<AttendanceModel>>> getCourseAttendance(
      String semester, String section, String courseId) async {
    try {
      if (teacher == null) throw Exception('Teacher data not found');

      String sectionId = '$semester-$section';

      final attendanceCollectionRef = _firestore
          .collection('departments')
          .doc(teacher!.teacherDept)
          .collection('teachers')
          .doc(teacher!.teacherCNIC)
          .collection('sections')
          .doc(sectionId)
          .collection('courses')
          .doc(courseId)
          .collection('attendance');

      final dateDocs = await attendanceCollectionRef.get();

      Map<String, List<AttendanceModel>> allAttendance = {};

      for (var dateDoc in dateDocs.docs) {
        final dateString = dateDoc.id;

        final data = dateDoc.data();
        if (data.containsKey('attendanceList')) {
          final List<dynamic> attendanceData = data['attendanceList'];
          final attendanceList = attendanceData
              .map((item) => AttendanceModel.fromMap(item))
              .toList();
          allAttendance[dateString] = attendanceList;
        }
      }

      return allAttendance; // key: date, value: list of attendance entries
    } catch (e) {
      throw Exception('Failed to fetch all attendance: ${e.toString()}');
    }
  }

  @override
  Future<void> markAttendance(String semester, String section,
      List<AttendanceModel> attendanceList) async {
    try {
      if (teacher == null) throw Exception('Teacher data not found');

      final batch = _firestore.batch();

      for (var attendance in attendanceList) {
        // Write to student-side
        final studentAttendanceRef = _firestore
            .collection('departments')
            .doc(teacher!.teacherDept)
            .collection('students')
            .doc(attendance.studentId)
            .collection('current_courses')
            .doc(attendance.course)
            .collection('attendance')
            .doc(attendance.date.toIso8601String());

        batch.set(studentAttendanceRef, attendance.toMap());
      }

      // Write to teacher-side
      final teacherAttendanceRef = _firestore
          .collection('departments')
          .doc(teacher!.teacherDept)
          .collection('teachers')
          .doc(teacher!.teacherCNIC)
          .collection('sections')
          .doc('$semester-$section')
          .collection('courses')
          .doc(attendanceList.first.course)
          .collection('attendance')
          .doc(attendanceList.first.date.toIso8601String());

      // Convert attendance list to a format Firestore can store
      final attendanceData = {
        'attendanceList':
            attendanceList.map((attendance) => attendance.toMap()).toList()
      };

      batch.set(teacherAttendanceRef, attendanceData);

      await batch.commit();
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to mark attendance: ${e.toString()}');
    }
  }
}
