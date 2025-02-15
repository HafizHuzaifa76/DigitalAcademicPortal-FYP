
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_academic_portal/features/admin/shared/courses/data/models/DeptCourseModel.dart';
import 'package:digital_academic_portal/features/admin/shared/courses/domain/entities/DepartmentCourse.dart';
import 'package:flutter/material.dart';

import '../models/SemesterCourseModel.dart';

abstract class CourseRemoteDataSource {
  Future<DeptCourseModel> addCourse(String deptName, DeptCourseModel course);
  Future<void> addCoursesList(String deptName, List<DepartmentCourse> courses);
  Future<DeptCourseModel> editCourse(String deptName, DeptCourseModel course);
  Future<void> deleteCourse(String deptName, DeptCourseModel course);
  Future<List<DeptCourseModel>> deptCourses(String deptName);
  Future<List<SemesterCourseModel>> semesterCourses(String deptName, String semester);
  Future<List<SemesterCourseModel>> allCourses();
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<DeptCourseModel> addCourse(String deptName, DeptCourseModel course) async {
    var ref = _firestore.collection('departments').doc(deptName);
    var courseRef = ref.collection('courses').doc(course.courseCode);

    var snapshot = await courseRef.get();

    if (!snapshot.exists) {
      await courseRef.set(course.toMap());
    } else {
      throw Exception('Course already exists');
    }

    return course;
  }

  @override
  Future<void> addCoursesList(String deptName, List<DepartmentCourse> courses) async {
    int chunkSize = 20;
    var ref = _firestore.collection('departments').doc(deptName);

    // Split the list into chunks of the specified size
    List<List<DepartmentCourse>> chunks = [];
    for (var i = 0; i < courses.length; i += chunkSize) {
      chunks.add(courses.sublist(i, i + chunkSize > courses.length ? courses.length : i + chunkSize));
    }

    for (var chunk in chunks) {
      await Future.wait(chunk.map((course) async {
        var courseRef = ref.collection('courses').doc(course.courseCode);
        var snapshot = await courseRef.get();

        if (!snapshot.exists) {
          await courseRef.set(DeptCourseModel.fromCourse(course).toMap());
        } else {
          debugPrint('Course ${course.courseName} already exists, skipping...');
        }
      }));
    }
  }

  @override
  Future<void> deleteCourse(String deptName, DeptCourseModel course) async {
    _firestore.collection('departments').doc(deptName)
        .collection('courses').doc(course.courseCode).delete();
  }

  @override
  Future<DeptCourseModel> editCourse(String deptName, DeptCourseModel course) async {
    var ref = _firestore.collection('departments').doc(deptName)
        .collection('courses').doc(course.courseCode);
    var snapshot = await ref.get();

    if (snapshot.exists) {
      await ref.set(course.toMap());
    } else {
      throw Exception('Course not exists');
    }
    return course;
  }
  //
  // @override
  // Future<DeptCourseModel> addCourse(String deptName, DeptCourseModel course) async {
  //   var ref = _firestore.collection('departments').doc(deptName)
  //       .collection('semesters')
  //       .doc(course.courseSemester);
  //   var courseRef = ref.collection('courses').doc(course.courseName);
  //
  //   var snapshot = await courseRef.get();
  //
  //   if (!snapshot.exists) {
  //     await courseRef.set(course.toMap());
  //     await ref.update({
  //       'numOfCourses': FieldValue.increment(1),
  //     });
  //   } else {
  //     throw Exception('Course already exists');
  //   }
  //
  //   return course;
  // }
  //
  // @override
  // Future<void> deleteCourse(String deptName, DeptCourseModel course) async {
  //   _firestore.collection('departments').doc(deptName)
  //       .collection('semesters')
  //       .doc(course.courseSemester)
  //       .collection('courses')
  //       .doc(course.courseName).delete();
  // }
  //
  // @override
  // Future<DeptCourseModel> editCourse(String deptName, DeptCourseModel course) async {
  //   var ref = _firestore.collection('departments').doc(deptName)
  //       .collection('semesters')
  //       .doc(course.courseSemester)
  //       .collection('courses')
  //       .doc(course.courseName);
  //   var snapshot = await ref.get();
  //
  //   if (snapshot.exists) {
  //     await ref.set(course.toMap());
  //   } else {
  //     throw Exception('Course not exists');
  //   }
  //
  //   return course;
  // }

  @override
  Future<List<DeptCourseModel>> deptCourses(String deptName) async {

    List<DeptCourseModel> allCourses = [];

    final semesterSnapshot = await _firestore.collection('departments')
        .doc(deptName)
        .collection('semesters')
        .get();

    for (final semesterDoc in semesterSnapshot.docs) {
      final semesterName = semesterDoc.id; // Assuming the document ID is the semester name

      final courseSnapshot = await semesterDoc.reference.collection('courses').get();

      final List<DeptCourseModel> courses = courseSnapshot.docs
          .map((doc) => DeptCourseModel.fromMap(doc.data()))
          .toList();

      allCourses.addAll(courses);
    }

    return allCourses;
  }
  //
  // @override
  // Future<List<DeptCourseModel>> deptCourses(String deptName) async {
  //
  //   List<DeptCourseModel> allCourses = [];
  //
  //   final semesterSnapshot = await _firestore.collection('departments')
  //       .doc(deptName)
  //       .collection('semesters')
  //       .get();
  //
  //   for (final semesterDoc in semesterSnapshot.docs) {
  //     final semesterName = semesterDoc.id; // Assuming the document ID is the semester name
  //
  //     final courseSnapshot = await semesterDoc.reference.collection('courses').get();
  //
  //     final List<DeptCourseModel> courses = courseSnapshot.docs
  //         .map((doc) => DeptCourseModel.fromMap(doc.data()))
  //         .toList();
  //
  //     allCourses.addAll(courses);
  //   }
  //
  //   return allCourses;
  // }


  @override
  Future<List<SemesterCourseModel>> allCourses() async {
    List<SemesterCourseModel> allCourses = [];

    // Fetch all departments
    final departmentSnapshot = await _firestore.collection('departments').get();

    for (var departmentDoc in departmentSnapshot.docs) {
      final departmentName = departmentDoc.id;

      // Fetch courses for each department
      final courses = await deptCourses(departmentName);

      // allCourses.addAll(courses);
    }

    return allCourses;
  }

  @override
  Future<List<SemesterCourseModel>> semesterCourses(String deptName, String semester) async {
    final querySnapshot = await _firestore.collection('departments')
        .doc(deptName)
        .collection('semesters')
        .doc(semester)
        .collection('courses')
        .get();

    return querySnapshot.docs
        .map((doc) => SemesterCourseModel.fromMap(doc.data()))
        .toList();
  }

}