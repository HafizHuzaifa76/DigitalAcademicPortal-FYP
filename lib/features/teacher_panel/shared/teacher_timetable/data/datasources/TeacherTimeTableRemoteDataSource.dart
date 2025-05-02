import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_academic_portal/shared/data/models/TimeTableEntryModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class TeacherTimeTableRemoteDataSource {
  Future<List<TimeTableEntryModel>> fetchTeacherTimetable(String teacherCNIC);
}

class TeacherTimeTableRemoteDataSourceImpl implements TeacherTimeTableRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<List<TimeTableEntryModel>> fetchTeacherTimetable(String teacherCNIC) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }
      
      String displayName = currentUser.displayName ?? '';
      List<String> parts = displayName.split(' | ');
      if (parts.length < 2) {
        throw Exception('Display name not formatted');
      }
      String teacherDept = parts[1];
      print('dept: $teacherDept');
      
      var semesterRef = _firestore.collection('departments').doc(teacherDept).collection('semesters');

      // First get all semesters in the department
      final QuerySnapshot semestersSnapshot = await semesterRef.get();

      List<TimeTableEntryModel> allTimeTableEntries = [];

      // For each semester, check its timetable
      for (var semester in semestersSnapshot.docs) {
        final QuerySnapshot timeTableSnapshot = await semesterRef.doc(semester.id).collection('timetable')
            .where('teacherCNIC', isEqualTo: teacherCNIC)
            .get();
        final semesterEntries = timeTableSnapshot.docs
            .map((doc) => TimeTableEntryModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList();
        
        allTimeTableEntries.addAll(semesterEntries);
      }

      return allTimeTableEntries;
    } catch (e) {
      throw Exception('Failed to fetch teacher timetable: ${e.toString()}');
    }
  }
}