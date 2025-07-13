import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../presentation/pages/StudentPanelDashboardPage.dart';
import '../../../student_courses/domain/entities/StudentCourse.dart';
import '../models/StudentAssignmentModel.dart';

abstract class StudentAssignmentRemoteDataSource {
  Future<List<StudentAssignmentModel>> getAssignments(StudentCourse course);
  Future<void> submitAssignment(
      String assignmentId, String fileUrl, StudentCourse course);
}

class StudentAssignmentRemoteDataSourceImpl
    implements StudentAssignmentRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var student = StudentPortalDashboardPage.studentProfile;

  @override
  Future<List<StudentAssignmentModel>> getAssignments(
      StudentCourse course) async {
    if (student == null) throw Exception('Student data not found');

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
        .map((doc) => StudentAssignmentModel.fromMap(doc.data(), doc.id,
            course.courseCode, course.courseName, student!.studentRollNo))
        .toList()
        .reversed
        .toList();
  }

  @override
  Future<void> submitAssignment(
      String assignmentId, String fileUrl, StudentCourse course) async {
    if (student == null) throw Exception('Student data not found');

    // Find the assignment document and update its submission status
    final assignmentDoc = await firestore
        .collection('departments')
        .doc(course.courseDept)
        .collection('semesters')
        .doc(course.courseSemester)
        .collection('courses')
        .doc(course.courseName)
        .collection('sections')
        .doc(course.courseSection)
        .collection('assignments')
        .doc(assignmentId)
        .get();

    if (assignmentDoc.exists) {
      // Get current studentAssignments map or create new one
      Map<String, dynamic> currentData = assignmentDoc.data() ?? {};
      Map<String, dynamic> studentAssignments =
          Map<String, dynamic>.from(currentData['studentAssignments'] ?? {});

      // Update the student's submission
      studentAssignments[student!.studentRollNo] = fileUrl;

      // Update the document
      await assignmentDoc.reference.update({
        'studentAssignments': studentAssignments,
      });
    } else {
      throw Exception('Assignment not found');
    }
  }
}
