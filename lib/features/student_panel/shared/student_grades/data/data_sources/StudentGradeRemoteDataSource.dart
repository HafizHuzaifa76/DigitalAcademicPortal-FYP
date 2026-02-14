import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/StudentGradeModel.dart';
import 'package:digital_academic_portal/shared/domain/entities/Student.dart';
import '../../../../../student_panel/presentation/pages/StudentDashboardPage.dart';

abstract class StudentGradeRemoteDataSource {
  Future<List<StudentGradeModel>> getStudentGrades(
      String studentId, String courseId);
  Future<List<StudentGradeModel>> getAllGrades(String studentId);
}

class StudentGradeRemoteDataSourceImpl implements StudentGradeRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Student? student = StudentDashboardPage.studentProfile;

  @override
  Future<List<StudentGradeModel>> getStudentGrades(
      String studentId, String courseId) async {
    if (student == null) {
      throw Exception('Student not found');
    }

    final querySnapshot = await _firestore
        .collection('departments')
        .doc(student!.studentDepartment)
        .collection('semesters')
        .doc(student!.studentSemester)
        .collection('courses')
        .doc(courseId)
        .collection('sections')
        .doc(student!.studentSection)
        .collection('grades')
        .get();

    return querySnapshot.docs
        .map((doc) => StudentGradeModel.fromMap(doc.data(),
            (doc.data()['obtainedMarks'][studentId] as num).toDouble()))
        .toList();
  }

  @override
  Future<List<StudentGradeModel>> getAllGrades(String studentId) async {
    final querySnapshot = await _firestore
        .collection('grades')
        .where('studentId', isEqualTo: studentId)
        .get();

    return querySnapshot.docs
        .map((doc) => StudentGradeModel.fromMap(doc.data(),
            (doc.data()['obtainedMarks'][studentId] as num).toDouble()))
        .toList();
  }
}
