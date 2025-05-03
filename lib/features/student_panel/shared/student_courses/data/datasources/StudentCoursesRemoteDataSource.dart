import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/StudentCourse.dart';
import '../models/StudentCourseModel.dart';

abstract class StudentCoursesRemoteDataSource {
  Future<List<StudentCourse>> fetchAllStudentCourses(String studentDept);
}

class StudentCoursesRemoteDataSourceImpl implements StudentCoursesRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<List<StudentCourse>> fetchAllStudentCourses(String studentDept) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception('No user logged in');

      final studentDoc = await _firestore
          .collection('students')
          .doc(currentUser.email)
          .get();

      if (!studentDoc.exists) throw Exception('Student not found');
      
      final studentData = studentDoc.data() as Map<String, dynamic>;
      final String semester = studentData['studentSemester'];
      final String section = studentData['studentSection'];

      final QuerySnapshot coursesSnapshot = await _firestore
          .collection('departments')
          .doc(studentDept)
          .collection('semesters')
          .doc(semester)
          .collection('sections')
          .doc(section)
          .collection('courses')
          .get();

      return coursesSnapshot.docs
          .map((doc) => StudentCourseModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch student courses: $e');
    }
  }
}