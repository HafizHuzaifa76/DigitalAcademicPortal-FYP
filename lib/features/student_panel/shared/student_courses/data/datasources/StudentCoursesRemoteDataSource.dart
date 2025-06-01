import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_academic_portal/features/student_panel/presentation/pages/StudentPanelDashboardPage.dart';
import 'package:digital_academic_portal/shared/domain/entities/Student.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../../../../../shared/data/models/StudentModel.dart';
import '../../domain/entities/StudentCourse.dart';
import '../models/StudentCourseModel.dart';

abstract class StudentCoursesRemoteDataSource {
  Future<List<StudentCourse>> getStudentCourses(String studentDept);
}

class StudentCoursesRemoteDataSourceImpl
    implements StudentCoursesRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<List<StudentCourse>> getStudentCourses(String studentDept) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception('No user logged in');
      final Student? studentData = StudentPortalDashboardPage.studentProfile;
      if (studentData == null || studentData.studentDepartment != studentDept)
        throw Exception('Student data not match');

      // Get student data first
      final studentRef = _firestore
          .collection('departments')
          .doc(studentDept)
          .collection('students')
          .doc(studentData.studentRollNo);

      // Check cached courses
      final cachedCoursesSnapshot =
          await studentRef.collection('current_courses').get();

      if (cachedCoursesSnapshot.docs.isNotEmpty) {
        return cachedCoursesSnapshot.docs
            .map((doc) => StudentCourseModel.fromMap(doc.data(), doc.data()))
            .toList();
      }

      // If no cached courses, fetch and cache them
      return await fetchAllStudentCourses(studentData);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting student courses: $e');
      }
      throw Exception('Failed to get student courses: $e');
    }
  }

  Future<List<StudentCourse>> fetchAllStudentCourses(Student studentData) async {
    final String studentDept = studentData.studentDepartment;
    final String rollNo = studentData.studentRollNo;
    final String semester = studentData.studentSemester;
    final String section = studentData.studentSection;
    final String shift = studentData.studentShift;

    final coursesRef = _firestore
        .collection('departments')
        .doc(studentDept)
        .collection('semesters')
        .doc(semester)
        .collection('courses');

    final coursesSnapshot = await coursesRef.get();
    List<StudentCourse> enrolledCourses = [];

    for (var courseDoc in coursesSnapshot.docs) {
      String courseSection = section;
      if(!courseSection.contains(shift)){
        courseSection = '$shift $section';
      }
      
      final sectionDoc = await coursesRef
          .doc(courseDoc.id)
          .collection('sections')
          .doc(courseSection)
          .get();

      if (sectionDoc.exists) {
        final sectionData = sectionDoc.data();
        final List<dynamic> enrolled = sectionData?['studentList'] ?? [];

        if (enrolled.contains(rollNo)) {
          if (sectionData?['teacherID'] == null) {
            throw Exception('No teacher assigned for this course');
          }
          // Create course model
          final courseModel = StudentCourseModel.fromMap(
              courseDoc.data(), sectionData as Map<String, dynamic>);
          enrolledCourses.add(courseModel);

          // Cache the course data
          await _firestore
              .collection('departments')
              .doc(studentDept)
              .collection('students')
              .doc(rollNo)
              .collection('current_courses')
              .doc(courseDoc.id)
              .set(courseModel.toMap());
        } else {
            throw Exception('rollNo not enrolled');
        }
      }
    }

    return enrolledCourses;
  }
}
