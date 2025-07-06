
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../presentation/pages/TeacherDashboardPage.dart';
import '../../domain/entities/TeacherCourse.dart';
import '../models/TeacherCourseModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../../shared/data/models/QueryModel.dart';

abstract class TeacherCourseRemoteDataSource {
  Future<List<TeacherCourseModel>> getTeacherCourses(String teacherDept);
  Future<Map<String, String>> getStudentNames(
      List<dynamic> studentIds, String courseDepartment);
  Future<List<QueryModel>> getQueries(TeacherCourse course);
  Future<void> respondToQuery(String queryId, String response, TeacherCourse course);
}

class TeacherCourseRemoteDataSourceImpl implements TeacherCourseRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final teacher = TeacherDashboardPage.teacherProfile;

  @override
  Future<List<TeacherCourseModel>> getTeacherCourses(String teacherDept) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }
      if (teacher == null) {
        throw Exception('Teacher profile data not found');
      }

      List<TeacherCourseModel> allCourses = [];

      final teacherRef = _firestore
          .collection('departments')
          .doc(teacherDept)
          .collection('teachers')
          .doc(teacher!.teacherCNIC);

      final QuerySnapshot sectionsSnapshot =
          await teacherRef.collection('sections').get();
      // If teacher found in this department

      for (var section in sectionsSnapshot.docs) {
        // Get courses in this section
        Map<String, dynamic> sectionData =
            section.data() as Map<String, dynamic>;
        final QuerySnapshot coursesSnapshot =
            await section.reference.collection('courses').get();

        // Add courses to the list
        final sectionCourses = coursesSnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          // Add section information to the course data
          data['courseSection'] = sectionData['sectionName'];
          return TeacherCourseModel.fromMap(data);
        }).toList();

        allCourses.addAll(sectionCourses);
      }

      return allCourses;
    } catch (e) {
      throw Exception('Failed to fetch teacher courses: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, String>> getStudentNames(
      List<dynamic> studentIds, String courseDepartment) async {
    try {
      Map<String, String> studentNames = {};

      if (studentIds.isEmpty) return studentNames;

      // Get students from the department
      final studentsRef = _firestore
          .collection('departments')
          .doc(courseDepartment)
          .collection('students');

      // Fetch each student by their ID
      for (var studentId in studentIds) {
        try {
          final studentDoc = await studentsRef.doc(studentId).get();
          if (studentDoc.exists) {
            final data = studentDoc.data() as Map<String, dynamic>;
            final studentName = data['studentName'] as String? ?? 'Unknown';
            studentNames[studentId] = studentName;
          } else {
            studentNames[studentId] = 'Student Not Found';
          }
        } catch (e) {
          studentNames[studentId] = 'Error Loading Student';
        }
      }

      return studentNames;
    } catch (e) {
      throw Exception('Failed to fetch student names: ${e.toString()}');
    }
  }

  @override
  Future<List<QueryModel>> getQueries(TeacherCourse course) async {
    try {
      if (teacher == null) {
        throw Exception('Teacher profile data not found');
      }
      
      final queriesSnapshot = await _firestore
          .collection('departments').doc(course.courseDept)
          .collection('teachers').doc(teacher!.teacherCNIC)
          .collection('sections').doc('${course.courseSemester}-${course.courseSection}')
          .collection('courses').doc(course.courseName)
          .collection('queries')
          .get();

      return queriesSnapshot.docs
          .map((doc) => QueryModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch queries: ${e.toString()}');
    }
  }

  @override
  Future<void> respondToQuery(String queryId, String response, TeacherCourse course) async {
    try {
      if (teacher == null) {
        throw Exception('Teacher profile data not found');
      }

      final queriesRef = _firestore
          .collection('departments').doc(course.courseDept)
          .collection('teachers').doc(teacher!.teacherCNIC)
          .collection('sections').doc('${course.courseSemester}-${course.courseSection}')
          .collection('courses').doc(course.courseName)
          .collection('queries');

      await queriesRef.doc(queryId).update({
        'response': response,
        'responseDate': DateTime.now().toIso8601String(),
        'status': 'responded',
      });

    } catch (e) {
      throw Exception('Failed to respond to query: ${e.toString()}');
    }
  }
}
