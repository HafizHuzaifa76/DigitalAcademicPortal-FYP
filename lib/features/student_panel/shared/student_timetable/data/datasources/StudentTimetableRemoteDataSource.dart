import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_academic_portal/shared/data/models/TimeTableEntryModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../presentation/pages/StudentDashboardPage.dart';

abstract class StudentTimetableRemoteDataSource {
  Future<List<TimeTableEntryModel>> fetchStudentTimetable();
}

class StudentTimetableRemoteDataSourceImpl
    implements StudentTimetableRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final student = StudentDashboardPage.studentProfile;

  @override
  Future<List<TimeTableEntryModel>> fetchStudentTimetable() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }
      if (student == null) {
        throw Exception('Student profile data not found');
      }

      // Get student timetable from Firestore
      // Path: departments -> student.studentDepartment -> semesters -> student.studentSemester -> timetable -> where section == student.studentSection
      final QuerySnapshot timeTableSnapshot = await _firestore
          .collection('departments')
          .doc(student!.studentDepartment)
          .collection('semesters')
          .doc(student!.studentSemester)
          .collection('timetable')
          .where('section', isEqualTo: student!.studentSection)
          .get();

      final List<TimeTableEntryModel> timeTableEntries = timeTableSnapshot.docs
          .map((doc) => TimeTableEntryModel.fromMap(
              doc.id, doc.data() as Map<String, dynamic>))
          .toList();

      print('timeTableEntries');
      print(timeTableEntries.length);
      return timeTableEntries;
    } catch (e) {
      throw Exception('Failed to fetch student timetable: ${e.toString()}');
    }
  }
}
