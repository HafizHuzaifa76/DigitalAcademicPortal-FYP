import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../student_courses/domain/entities/StudentCourse.dart';
import '../models/StudentAssignmentModel.dart';

abstract class StudentAssignmentRemoteDataSource {
  Future<List<StudentAssignmentModel>> getAssignments(StudentCourse course);
  Future<void> submitAssignment(String assignmentId, String fileUrl);
}

class StudentAssignmentRemoteDataSourceImpl
    implements StudentAssignmentRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<StudentAssignmentModel>> getAssignments(
      StudentCourse course) async {
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
        .map((doc) => StudentAssignmentModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> submitAssignment(String assignmentId, String fileUrl) async {
    // Find the assignment document and update its submission status
    final assignmentQuery = await firestore
        .collectionGroup('assignments')
        .where(FieldPath.documentId, isEqualTo: assignmentId)
        .get();
    if (assignmentQuery.docs.isNotEmpty) {
      final docRef = assignmentQuery.docs.first.reference;
      await docRef.update({
        'status': 'Submitted',
        'submittedFileUrl': fileUrl,
        'submittedAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
