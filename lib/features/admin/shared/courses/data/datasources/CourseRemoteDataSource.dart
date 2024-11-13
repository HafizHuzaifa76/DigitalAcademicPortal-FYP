
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/CourseModel.dart';

abstract class CourseRemoteDataSource {
  Future<CourseModel> addCourse(String deptName, CourseModel course);
  Future<CourseModel> editCourse(String deptName, CourseModel course);
  Future<void> deleteCourse(String deptName, CourseModel course);
  Future<List<CourseModel>> deptCourses(String deptName);
  Future<List<CourseModel>> semesterCourses(String deptName, String semester);
  Future<List<CourseModel>> allCourses();
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<CourseModel> addCourse(String deptName, CourseModel course) async {
    var ref = _firestore.collection('departments').doc(deptName)
        .collection('semesters')
        .doc(course.courseSemester);
    var courseRef = ref.collection('courses').doc(course.courseName);

    var snapshot = await courseRef.get();

    if (!snapshot.exists) {
      await courseRef.set(course.toMap());
      await ref.update({
        'numOfCourses': FieldValue.increment(1),
      });
    } else {
      throw Exception('Course already exists');
    }

    return course;
  }

  @override
  Future<void> deleteCourse(String deptName, CourseModel course) async {
    _firestore.collection('departments').doc(deptName)
        .collection('semesters')
        .doc(course.courseSemester)
        .collection('courses')
        .doc(course.courseName).delete();
  }

  @override
  Future<CourseModel> editCourse(String deptName, CourseModel course) async {
    var ref = _firestore.collection('departments').doc(deptName)
        .collection('semesters')
        .doc(course.courseSemester)
        .collection('courses')
        .doc(course.courseName);
    var snapshot = await ref.get();

    if (snapshot.exists) {
      await ref.set(course.toMap());
    } else {
      throw Exception('Course not exists');
    }

    return course;
  }

  @override
  Future<List<CourseModel>> deptCourses(String deptName) async {

    List<CourseModel> allCourses = [];

    final semesterSnapshot = await _firestore.collection('departments')
        .doc(deptName)
        .collection('semesters')
        .get();

    for (final semesterDoc in semesterSnapshot.docs) {
      final semesterName = semesterDoc.id; // Assuming the document ID is the semester name

      final courseSnapshot = await semesterDoc.reference.collection('courses').get();

      final List<CourseModel> courses = courseSnapshot.docs
          .map((doc) => CourseModel.fromMap(doc.data()))
          .toList();

      allCourses.addAll(courses);
    }

    return allCourses;
  }


  @override
  Future<List<CourseModel>> allCourses() async {
    List<CourseModel> allCourses = [];

    // Fetch all departments
    final departmentSnapshot = await _firestore.collection('departments').get();

    for (var departmentDoc in departmentSnapshot.docs) {
      final departmentName = departmentDoc.id;

      // Fetch courses for each department
      final courses = await deptCourses(departmentName);

      allCourses.addAll(courses);
    }

    return allCourses;
  }

  @override
  Future<List<CourseModel>> semesterCourses(String deptName, String semester) async {
    final querySnapshot = await _firestore.collection('departments')
        .doc(deptName)
        .collection('semesters')
        .doc(semester)
        .collection('courses')
        .get();

    return querySnapshot.docs
        .map((doc) => CourseModel.fromMap(doc.data()))
        .toList();
  }

}