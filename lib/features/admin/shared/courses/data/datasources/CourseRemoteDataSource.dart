
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/CourseModel.dart';

abstract class CourseRemoteDataSource {
  Future<CourseModel> addCourse(String deptName, CourseModel course);
  Future<CourseModel> editCourse(String deptName, CourseModel course);
  Future<void> deleteCourse(String deptName, String course);
  Future<List<CourseModel>> deptCourses(String deptName);
  Future<List<CourseModel>> semesterCourses(String deptName, String semester);
  Future<List<CourseModel>> allCourses();
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<CourseModel> addCourse(String deptName, CourseModel course) async {
    var ref = _firestore.collection('departments').doc(deptName).collection('courses').doc(course.courseName);
    var snapshot = await ref.get();

    if (!snapshot.exists) {
      await ref.set(course.toMap());
    } else {
      throw Exception('Course already exists');
    }

    return course;
  }

  @override
  Future<void> deleteCourse(String deptName, String courseName) async {
    _firestore.collection('departments').doc(deptName).collection('courses').doc(courseName).delete();
  }

  @override
  Future<CourseModel> editCourse(String deptName, CourseModel course) async {
    var ref = _firestore.collection('departments').doc(deptName).collection('courses').doc(course.courseName);
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
    final querySnapshot = await _firestore.collection('departments').doc(deptName).collection('courses').get();
    return querySnapshot.docs
        .map((doc) => CourseModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<List<CourseModel>> allCourses() async {
    List<CourseModel> allCourses = [];

    // Fetch all departments
    final departmentSnapshot = await _firestore.collection('departments').get();

    for (var departmentDoc in departmentSnapshot.docs) {
      final departmentName = departmentDoc.id;

      // Fetch courses for each department
      final courseSnapshot = await _firestore
          .collection('departments').doc(departmentName)
          .collection('courses').get();

      allCourses.addAll(courseSnapshot.docs
          .map((doc) => CourseModel.fromMap(doc.data()))
          .toList());
    }

    return allCourses;
  }

  @override
  Future<List<CourseModel>> semesterCourses(String deptName, String semester) async {
    final querySnapshot = await _firestore.collection('departments')
        .doc(deptName).collection('courses')
        .where('courseDept',  isEqualTo: deptName)
        .where('courseSemester', isEqualTo: semester)
        .get();

    return querySnapshot.docs
        .map((doc) => CourseModel.fromMap(doc.data()))
        .toList();
  }

}