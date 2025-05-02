import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/TeacherCourseModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class TeacherCourseRemoteDataSource {
  Future<List<TeacherCourseModel>> getTeacherCourses(String teacherDept);
}

class TeacherCourseRemoteDataSourceImpl implements TeacherCourseRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<List<TeacherCourseModel>> getTeacherCourses(String teacherDept) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      List<TeacherCourseModel> allCourses = [];
      
      final QuerySnapshot teacherSnapshot = await _firestore
          .collection('departments')
          .doc(teacherDept)
          .collection('teachers')
          .where('teacherEmail', isEqualTo: currentUser.email)
          .get();

      // If teacher found in this department
      if (teacherSnapshot.docs.isNotEmpty) {
        // Get all sections for this teacher
        final QuerySnapshot sectionsSnapshot = await teacherSnapshot.docs.first.reference
            .collection('sections')
            .get();

        // Iterate through each section
        for (var section in sectionsSnapshot.docs) {
          // Get courses in this section
            Map<String, dynamic> sectionData = section.data() as Map<String, dynamic>;
          final QuerySnapshot coursesSnapshot = await section.reference
              .collection('courses')
              .get();

          // Add courses to the list
          final sectionCourses = coursesSnapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            // Add section information to the course data
            data['courseSection'] = sectionData['sectionName'];
            return TeacherCourseModel.fromMap(data);
          }).toList();

          allCourses.addAll(sectionCourses);
        }
      }

      return allCourses;
    } catch (e) {
      throw Exception('Failed to fetch teacher courses: ${e.toString()}');
    }
  }
}