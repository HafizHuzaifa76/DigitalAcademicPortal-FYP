
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_academic_portal/shared/domain/entities/Teacher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/SectionModel.dart';

abstract class SectionRemoteDataSource{
  Future<SectionModel> addSection(String deptName, String semester, SectionModel section);
  Future<SectionModel> editSection(String deptName, String semester, SectionModel section);
  Future<void> deleteSection(String deptName, String semester, String sectionName);
  Future<void> enrollStudentListInSection(String deptName, String semester, String sectionName, List<String> studentList);
  Future<List<SectionModel>> allSections(String deptName, String semester);
  Future<void> assignTeacherToCourses(String deptName, String semester, String section, Map<String, dynamic> coursesTeachersMap);
  Future<Map<String, String?>> fetchAssignedTeachers(String deptName, String semester, String section);
  Future<void> editAssignedTeacher(String deptName, String semester, String section, String courseName, Teacher newTeacher);

}

class SectionRemoteDataSourceImpl implements SectionRemoteDataSource{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<SectionModel> addSection(String deptName, String semester, SectionModel section) async {
    var courseRef = _firestore.collection('departments').doc(deptName).collection('semesters').doc(semester);
    var ref = courseRef.collection('sections').doc(section.sectionID);
    var snapshot = await ref.get();

    if (!snapshot.exists) {
      await ref.set(section.toMap());
    } else {
      throw Exception('Section already exists');
    }

    return section;
  }

  @override
  Future<void> deleteSection(String deptName, String semester, String sectionID) async {
    var courseRef = _firestore.collection('departments').doc(deptName).collection('semesters').doc(semester);
    courseRef.collection('sections').doc(sectionID).delete();
  }

  @override
  Future<SectionModel> editSection(String deptName, String semester, SectionModel section) async {
    var courseRef = _firestore.collection('departments').doc(deptName).collection('semesters').doc(semester);
    var ref = courseRef.collection('sections').doc(section.sectionID);
    var snapshot = await ref.get();

    if (snapshot.exists) {
      await ref.set(section.toMap());
    } else {
      throw Exception('Section not exists');
    }

    return section;
  }

  @override
  Future<List<SectionModel>> allSections(String deptName, String semester) async {
    var courseRef = _firestore.collection('departments').doc(deptName).collection('semesters').doc(semester);
    final querySnapshot = await courseRef.collection('sections').get();
    return querySnapshot.docs
        .map((doc) => SectionModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future assignTeacherToCourses(String deptName, String semester, String section, Map<String, dynamic> coursesTeachersMap) async {
    try {
      var departmentRef = _firestore.collection('departments').doc(deptName);
      var semesterRef = departmentRef.collection('semesters').doc(semester);
      var allCourses = coursesTeachersMap.keys;
      print('allCourses.length ${allCourses.length}');

      for (var course in allCourses){
        if (coursesTeachersMap[course] is Teacher) {
          print('Course: $course, teacher: ${coursesTeachersMap[course].teacherName}');

          var courseRef = semesterRef.collection('courses').doc(course);
          var courseSnapshot = await courseRef.get();
          
          if (courseSnapshot.exists) {
            print('courseSnapshot exists');
            var teacherRef = departmentRef.collection('teachers').doc(coursesTeachersMap[course]!.teacherCNIC)
                .collection('sections').doc('$semester-$section');
          
            var ref = courseRef.collection('sections').doc(section);
            ref.set({
              'teacherName': coursesTeachersMap[course]!.teacherName,
              'teacherID': coursesTeachersMap[course]!.teacherCNIC,
            }, SetOptions(merge: true)).then((onValue)=>
                print('teacher assigned to section'));

            await teacherRef.set({'sectionName': section}, SetOptions(merge: true));
            await teacherRef.collection('courses').doc(course).set(courseSnapshot.data()!, SetOptions(merge: true));
            print('section added to teacher');

          }
        } else {
          if (kDebugMode) {
            print('It is not Teacher');
          }
        }
      }
    } catch (e) {
      throw Exception('Error adding teacher: $e');
    }
  }

  @override
  Future<Map<String, String?>> fetchAssignedTeachers(String deptName, String semester, String section) async {
    Map<String, String?> assignedTeachers = {};

    try {
      var departmentRef = _firestore.collection('departments').doc(deptName);
      var semesterRef = departmentRef.collection('semesters').doc(semester);
      var coursesSnapshot = await semesterRef.collection('courses').get();

      for (var courseDoc in coursesSnapshot.docs) {
        var courseName = courseDoc.id;
        var sectionRef = courseDoc.reference.collection('sections').doc(section);
        var sectionSnapshot = await sectionRef.get();

        if (sectionSnapshot.exists && sectionSnapshot.data() != null) {
          var data = sectionSnapshot.data()!;
          if (data.containsKey('teacherID')) {
            assignedTeachers[courseName] = data['teacherID'];
          } else {
            assignedTeachers[courseName] = null;
          }
        } else {
          assignedTeachers[courseName] = null;
        }
      }
    } catch (e) {
      print('Error fetching assigned teachers: $e');
      throw Exception('Failed to fetch assigned teachers');
    }

    return assignedTeachers;
  }

  @override
  Future<void> editAssignedTeacher(String deptName, String semester, String section, String courseName, Teacher newTeacher) async {
    try {
      var departmentRef = _firestore.collection('departments').doc(deptName);
      var semesterRef = departmentRef.collection('semesters').doc(semester);
      var courseRef = semesterRef.collection('courses').doc(courseName);
      var sectionRef = courseRef.collection('sections').doc(section);

      // Check if the course exists
      var courseSnapshot = await courseRef.get();
      var sectionSnapshot = await sectionRef.get();
      if (!courseSnapshot.exists) {
        throw Exception("Course not found!");
      }
      if (!sectionSnapshot.exists) {
        throw Exception("Course not found!");
      }

      var oldTeacherID = sectionSnapshot['teacherID'];

      // Update the assigned teacher in the section document
      await sectionRef.set({
        'teacherName': newTeacher.teacherName,
        'teacherID': newTeacher.teacherCNIC,
      }, SetOptions(merge: true));
      print("Teacher updated successfully!");

      // Update teacher's courses collection (remove old and add new if needed)
      var oldTeacherRef = departmentRef.collection('teachers').doc(oldTeacherID).collection('sections').doc('$semester-$section').collection('courses').doc(courseName);
      await oldTeacherRef.delete();

      var newTeacherRef = departmentRef.collection('teachers').doc(newTeacher.teacherCNIC).collection('sections').doc('$semester-$section');
      await newTeacherRef.set({'sectionName': section}, SetOptions(merge: true));
      await newTeacherRef.collection('courses').doc(courseName).set(courseSnapshot.data()!, SetOptions(merge: true));

      print("Updated teacher's assigned courses!");
    } catch (e) {
      print("Error updating assigned teacher: $e");
      throw Exception("Failed to update teacher");
    }
  }

  @override
  Future<void> enrollStudentListInSection(String deptName, String semester, String sectionName, List<String> studentList) async {
    var ref = _firestore.collection('departments').doc(deptName).collection('semesters').doc(semester)
        .collection('sections').doc(sectionName);

    await ref.set({
      'studentsList': studentList
    });
  }

}