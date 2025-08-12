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

  /// Fetch total count of teachers across all departments (parallel)
  Future<int> getTeachersCount() async {
    try {
      final departmentsSnapshot =
          await _firestore.collection('departments').get();

      // Each async callback returns int
      final futures = departmentsSnapshot.docs.map((deptDoc) async {
        final teachersSnapshot =
            await deptDoc.reference.collection('teachers').get();
        return teachersSnapshot.docs.length; // returns int
      }).toList();

      // Wait for all and sum results
      final List<int> counts = await Future.wait(futures);
      return counts.fold<int>(0, (sum, count) => sum + count);
    } catch (e) {
      print('Error fetching teachers count: $e');
      return 0;
    }
  }

  /// Fetch total count of students across all departments (parallel)
  Future<int> getStudentsCount() async {
    try {
      final departmentsSnapshot =
          await _firestore.collection('departments').get();

      final futures = departmentsSnapshot.docs.map((deptDoc) async {
        final studentsSnapshot =
            await deptDoc.reference.collection('students').get();
        return studentsSnapshot.docs.length; // returns int
      }).toList();

      final List<int> counts = await Future.wait(futures);
      return counts.fold<int>(0, (sum, count) => sum + count);
    } catch (e) {
      print('Error fetching students count: $e');
      return 0;
    }
  }

  /// Fetch all dashboard statistics at once (parallel)
  Future<Map<String, int>> getDashboardStats() async {
    try {
      final results = await Future.wait([
        getDepartmentsCount(),
        getTeachersCount(),
        getStudentsCount(),
      ]);

      return {
        'departments': results[0],
        'teachers': results[1],
        'students': results[2],
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
