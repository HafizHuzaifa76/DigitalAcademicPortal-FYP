import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch total count of departments
  Future<int> getDepartmentsCount() async {
    try {
      final querySnapshot = await _firestore.collection('departments').get();
      return querySnapshot.docs.length;
    } catch (e) {
      print('Error fetching departments count: $e');
      return 0;
    }
  }

  /// Fetch total count of teachers across all departments
  Future<int> getTeachersCount() async {
    try {
      int totalTeachers = 0;
      final departmentsSnapshot =
          await _firestore.collection('departments').get();

      for (var deptDoc in departmentsSnapshot.docs) {
        final teachersSnapshot =
            await deptDoc.reference.collection('teachers').get();
        totalTeachers += teachersSnapshot.docs.length;
      }

      return totalTeachers;
    } catch (e) {
      print('Error fetching teachers count: $e');
      return 0;
    }
  }

  /// Fetch total count of students across all departments
  Future<int> getStudentsCount() async {
    try {
      int totalStudents = 0;
      final departmentsSnapshot =
          await _firestore.collection('departments').get();

      for (var deptDoc in departmentsSnapshot.docs) {
        final studentsSnapshot =
            await deptDoc.reference.collection('students').get();
        totalStudents += studentsSnapshot.docs.length;
      }

      return totalStudents;
    } catch (e) {
      print('Error fetching students count: $e');
      return 0;
    }
  }

  /// Fetch all dashboard statistics at once
  Future<Map<String, int>> getDashboardStats() async {
    try {
      final departmentsCount = await getDepartmentsCount();
      final teachersCount = await getTeachersCount();
      final studentsCount = await getStudentsCount();

      return {
        'departments': departmentsCount,
        'teachers': teachersCount,
        'students': studentsCount,
      };
    } catch (e) {
      print('Error fetching dashboard stats: $e');
      return {
        'departments': 0,
        'teachers': 0,
        'students': 0,
      };
    }
  }
}
