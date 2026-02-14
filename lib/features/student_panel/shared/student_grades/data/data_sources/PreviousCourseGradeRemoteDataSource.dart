import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../shared/data/models/PreviousCourseGradeModel.dart';
import 'package:digital_academic_portal/shared/domain/entities/Student.dart';
import '../../../../../student_panel/presentation/pages/StudentDashboardPage.dart';

abstract class PreviousCourseGradeRemoteDataSource {
  Future<List<PreviousCourseGradeModel>> getPreviousCourseGrades(
      String studentId);
  Future<List<PreviousCourseGradeModel>> getPreviousSemesterGrades(
      String studentId, String semester);
}

class PreviousCourseGradeRemoteDataSourceImpl
    implements PreviousCourseGradeRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Student? student = StudentDashboardPage.studentProfile;

  @override
  Future<List<PreviousCourseGradeModel>> getPreviousCourseGrades(
      String studentId) async {
    try {
      // Get the student's department from the static profile
      final studentDept = student?.studentDepartment;
      final studentRollNo = student?.studentRollNo;

      if (studentDept == null || studentRollNo == null) {
        throw Exception('Student department or roll number not found');
      }

      final querySnapshot = await _firestore
          .collection('departments')
          .doc(studentDept)
          .collection('students')
          .doc(studentRollNo)
          .collection('previous_courses')
          .get();

      return querySnapshot.docs
          .map((doc) => PreviousCourseGradeModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch previous course grades: $e');
    }
  }

  @override
  Future<List<PreviousCourseGradeModel>> getPreviousSemesterGrades(
      String studentId, String semester) async {
    try {
      // Get the student's department from the static profile
      final studentDept = student?.studentDepartment;
      final studentRollNo = student?.studentRollNo;

      if (studentDept == null || studentRollNo == null) {
        throw Exception('Student department or roll number not found');
      }

      final querySnapshot = await _firestore
          .collection('departments')
          .doc(studentDept)
          .collection('students')
          .doc(studentRollNo)
          .collection('previous_courses')
          .get();

      return querySnapshot.docs
          .map((doc) => PreviousCourseGradeModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch previous semester grades: $e');
    }
  }
}
