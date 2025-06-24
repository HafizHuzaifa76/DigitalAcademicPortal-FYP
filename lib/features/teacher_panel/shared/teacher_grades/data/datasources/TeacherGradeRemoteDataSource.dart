import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_academic_portal/features/teacher_panel/presentation/pages/TeacherDashboardPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';
import '../../domain/entities/Grade.dart';
import '../../../../../../shared/data/models/PreviousCourseGradeModel.dart';

abstract class TeacherGradeRemoteDataSource {
  Future<Map<String, dynamic>> getMarkingGrades(
    TeacherCourse course,
    String gradeId,
  );
  Future<void> saveMarkingGrades(
    TeacherCourse course,
    String gradeId,
    Map<String, dynamic> obtainedGrades,
  );
  Future<List<Grade>> getCourseGrades(TeacherCourse course);
  Future<void> createCourseGrade(TeacherCourse course, Grade grade);
  Future<void> deleteGrade(TeacherCourse course, String gradeId);
  Future<void> updateGrade(TeacherCourse course, Grade grade);
  Future<void> submitCourseGrades(
      List<PreviousCourseGradeModel> grades, TeacherCourse course);
}

class TeacherGradeRemoteDataSourceImpl implements TeacherGradeRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final teacher = TeacherDashboardPage.teacherProfile;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<Map<String, dynamic>> getMarkingGrades(
    TeacherCourse course,
    String gradeId,
  ) async {
    try {
      if (teacher == null) throw Exception('Teacher data not found');

      final gradesRef = _firestore
          .collection('departments')
          .doc(teacher!.teacherDept)
          .collection('semesters')
          .doc(course.courseSemester)
          .collection('courses')
          .doc(course.courseName)
          .collection('sections')
          .doc(course.courseSection)
          .collection('grades')
          .doc(gradeId);

      final gradesSnapshot = await gradesRef.get();
      if (!gradesSnapshot.exists) {
        throw Exception('Grade not found!');
      }

      final data = gradesSnapshot.data();
      if (data == null) {
        throw Exception('Grade data not found!');
      }

      final obtainedMarks = data['obtainedMarks'] as Map<String, dynamic>?;
      if (obtainedMarks == null) {
        throw Exception('Obtained Marks not found!');
      }

      return obtainedMarks;
    } catch (e) {
      throw Exception('Failed to fetch grades: ${e.toString()}');
    }
  }

  @override
  Future<void> saveMarkingGrades(
    TeacherCourse course,
    String gradeId,
    Map<String, dynamic> obtainedGrades,
  ) async {
    try {
      if (teacher == null) throw Exception('Teacher data not found');

      final ref = _firestore
          .collection('departments')
          .doc(teacher!.teacherDept)
          .collection('semesters')
          .doc(course.courseSemester)
          .collection('courses')
          .doc(course.courseName)
          .collection('sections')
          .doc(course.courseSection)
          .collection('grades')
          .doc(gradeId);

      await ref.set({'obtainedMarks': obtainedGrades}, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save grades: ${e.toString()}');
    }
  }

  @override
  Future<List<Grade>> getCourseGrades(TeacherCourse course) async {
    try {
      if (teacher == null) throw Exception('Teacher data not found');

      final ref = _firestore
          .collection('departments')
          .doc(teacher!.teacherDept)
          .collection('semesters')
          .doc(course.courseSemester)
          .collection('courses')
          .doc(course.courseName)
          .collection('sections')
          .doc(course.courseSection)
          .collection('grades');

      final snapshot = await ref.get();
      return snapshot.docs.map((doc) => Grade.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to fetch grades: ${e.toString()}');
    }
  }

  @override
  Future<void> createCourseGrade(TeacherCourse course, Grade grade) async {
    try {
      if (teacher == null) throw Exception('Teacher data not found');

      final ref = _firestore
          .collection('departments')
          .doc(teacher!.teacherDept)
          .collection('semesters')
          .doc(course.courseSemester)
          .collection('courses')
          .doc(course.courseName)
          .collection('sections')
          .doc(course.courseSection)
          .collection('grades')
          .doc(grade.id);

      await ref.set(grade.toMap());
    } catch (e) {
      throw Exception('Failed to create grade: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteGrade(TeacherCourse course, String gradeId) async {
    try {
      if (teacher == null) throw Exception('Teacher data not found');

      final ref = _firestore
          .collection('departments')
          .doc(teacher!.teacherDept)
          .collection('semesters')
          .doc(course.courseSemester)
          .collection('courses')
          .doc(course.courseName)
          .collection('sections')
          .doc(course.courseSection)
          .collection('grades')
          .doc(gradeId);

      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete grade: $e');
    }
  }

  @override
  Future<void> updateGrade(TeacherCourse course, Grade grade) async {
    try {
      if (teacher == null) throw Exception('Teacher data not found');

      final ref = _firestore
          .collection('departments')
          .doc(teacher!.teacherDept)
          .collection('semesters')
          .doc(course.courseSemester)
          .collection('courses')
          .doc(course.courseName)
          .collection('sections')
          .doc(course.courseSection)
          .collection('grades')
          .doc(grade.id);

      await ref.update(grade.toMap());
    } catch (e) {
      throw Exception('Failed to update grade: $e');
    }
  }

  @override
  Future<void> submitCourseGrades(List<PreviousCourseGradeModel> grades, TeacherCourse course) async {
    try {
      if (teacher == null) throw Exception('Teacher data not found');

      course = TeacherCourse(courseCode: 'CS-PHY-1101', courseName: 'Applied Physics', courseDept: 'Computer Science', courseSemester: 'SEM-I', courseType: 'compulsory', courseCreditHours: 3, courseSection: 'Evening E1', studentIds: []);
      // Fetch previous grades from all students in Computer Science department
      final studentsSnapshot = await _firestore
          .collection('departments')
          .doc('Computer Science')
          .collection('students')
          .get();

      final List<PreviousCourseGradeModel> allPreviousGrades = [];
      
      for (final studentDoc in studentsSnapshot.docs) {
        final previousCoursesSnapshot = await studentDoc.reference
            .collection('previous_courses')
            .limit(1) // Get only first document
            .get();
            
        if (previousCoursesSnapshot.docs.isNotEmpty) {
          final gradeData = previousCoursesSnapshot.docs.first.data();
          final grade = PreviousCourseGradeModel.fromMap(gradeData);
          allPreviousGrades.add(grade);
        }
      }

      grades = allPreviousGrades;

      // Submit grades to students' previous courses
      final batch = _firestore.batch();
      for (final grade in grades) {
        // // Add to previous_courses collection
        // final previousCourseRef = _firestore
        //     .collection('departments')
        //     .doc(teacher!.teacherDept)
        //     .collection('students')
        //     .doc(grade.studentId)
        //     .collection('previous_courses')
        //     .doc(grade.course);
        // batch.set(previousCourseRef, grade.toMap());

        // Remove from current_courses collection
        final currentCourseRef = _firestore
            .collection('departments')
            .doc(teacher!.teacherDept)
            .collection('students')
            .doc(grade.studentId)
            .collection('current_courses')
            .doc(grade.course);
        batch.delete(currentCourseRef);
      }

      // Remove the course from teacher's course list
      // final teacherCourseRef = _firestore
      //     .collection('departments')
      //     .doc(teacher!.teacherDept)
      //     .collection('teachers')
      //     .doc(teacher!.teacherCNIC)
      //     .collection('sections')
      //     .doc('${course.courseSemester}-${course.courseSection}')
      //     .collection('courses')
      //     .doc(course.courseName);

      // batch.delete(teacherCourseRef);

      // Delete the section from departments structure
      final sectionRef = _firestore
          .collection('departments')
          .doc(teacher!.teacherDept)
          .collection('semesters')
          .doc(course.courseSemester)
          .collection('courses')
          .doc(course.courseName)
          .collection('sections')
          .doc(course.courseSection);

      batch.delete(sectionRef);

      await batch.commit();
    } on Exception catch (e) {
      throw Exception('Failed to Submit Grades: $e');
    }
  }
}
