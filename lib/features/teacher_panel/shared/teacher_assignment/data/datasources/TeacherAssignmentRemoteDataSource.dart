import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import 'package:digital_academic_portal/features/teacher_panel/presentation/pages/TeacherDashboardPage.dart';
import '../models/AssignmentModel.dart';

abstract class TeacherAssignmentRemoteDataSource {
  /// courseId is TeacherCourse.courseCode
  Future<List<AssignmentModel>> getAssignments(TeacherCourse course);
  Future<void> createAssignment(
      TeacherCourse course, AssignmentModel assignment);
}

class TeacherAssignmentRemoteDataSourceImpl
    implements TeacherAssignmentRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final teacher = TeacherDashboardPage.teacherProfile;

  @override
  Future<List<AssignmentModel>> getAssignments(TeacherCourse course) async {
    final snapshot = await firestore
        .collection('departments')
        .doc(course.courseDept)
        .collection('semesters')
        .doc(course.courseSemester)
        .collection('courses')
        .doc(course.courseName)
        .collection('sections')
        .doc(course.courseSection)
        .collection('assignments')
        .get();

    return snapshot.docs
        .map((doc) => AssignmentModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> createAssignment(
      TeacherCourse course, AssignmentModel assignment) async {
    await firestore
        .collection('departments')
        .doc(course.courseDept)
        .collection('semesters')
        .doc(course.courseSemester)
        .collection('courses')
        .doc(course.courseName)
        .collection('sections')
        .doc(course.courseSection)
        .collection('assignments')
        .add(assignment.toMap());
  }
}
