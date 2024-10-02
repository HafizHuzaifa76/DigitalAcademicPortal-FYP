
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_academic_portal/features/admin/shared/sections/data/models/SectionModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/StudentModel.dart';

abstract class StudentRemoteDataSource{
  Future<StudentModel> addStudent(StudentModel student);
  Future<StudentModel> editStudent(StudentModel student);
  Future<void> deleteStudent(String studentID);
  Future<List<StudentModel>> allStudents();
  Future<List<StudentModel>> getStudentsByDepartment(String deptName);
  Future<List<StudentModel>> getStudentsBySemester(String deptName, String semester);
  Future<void> setSectionLimit(String deptName, String semester, int limit);
}

class StudentRemoteDataSourceImpl implements StudentRemoteDataSource{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<StudentModel> addStudent(StudentModel student) async {
    var studentRef = _firestore.collection('students').doc(student.studentEmail);
    var studentSnapshot = await studentRef.get();

    if (studentSnapshot.exists) {
      throw Exception('Student already exists');
    }

    String assignedSection = await _assignSection(student);
    student.studentSection = assignedSection;

    await _createStudentAccount(student);

    await _createCompulsoryCourseSections(student, assignedSection);

    return student;
  }

  Future<void> _createStudentAccount(StudentModel student) async {
    var studentRef = _firestore.collection('students').doc(student.studentEmail);
    await _auth.createUserWithEmailAndPassword(email: student.studentEmail, password: student.studentCNIC);
    await studentRef.set(student.toMap());
  }

  Future<void> _createCompulsoryCourseSections(StudentModel student, String sectionName) async {
    var coursesRef = _firestore.collection('departments')
        .doc(student.studentDepartment)
        .collection('semesters')
        .doc(student.studentSemester)
        .collection('courses');

    var compulsoryCoursesQuery = await coursesRef.where('courseType', isEqualTo: 'compulsory').get();

    for (var courseDoc in compulsoryCoursesQuery.docs) {
      var courseData = courseDoc.data();
      String courseId = courseDoc.id;

      var sectionRef = coursesRef.doc(courseId).collection('sections').doc(sectionName);
      var sectionSnapshot = await sectionRef.get();

      if (!sectionSnapshot.exists) {
        await sectionRef.set({
          'sectionName': sectionName,
          'shift': student.studentShift,
          'totalStudents': 1,
          'studentList': [student.studentRollNo],
        });
      } else {
        var sectionData = sectionSnapshot.data();
        List<dynamic> studentList = sectionData?['studentList'] ?? [];
        studentList.add(student.studentRollNo);

        await sectionRef.update({
          'totalStudents': studentList.length,
          'studentList': studentList,
        });
      }
    }
  }


  Future<String> _assignSection(StudentModel student) async {
    int sectionLimit = await _getSectionLimit(student.studentDepartment, student.studentSemester);

    if (student.studentShift.toLowerCase() == 'morning') {
      return await _assignToShiftSection(student.studentDepartment, student.studentSemester, 'morning', sectionLimit, student);
    } else if (student.studentShift.toLowerCase() == 'evening') {
      return await _assignToShiftSection(student.studentDepartment, student.studentSemester, 'evening', sectionLimit, student);
    }

    throw Exception('Invalid student shift');
  }

  Future<int> _getSectionLimit(String deptName, String semester) async {
    var semesterRef = _firestore.collection('departments').doc(deptName).collection('semesters').doc(semester);
    var semesterDoc = await semesterRef.get();
    return semesterDoc.data()?['sectionLimit'] ?? 30; // Default section limit is 30
  }

  Future<String> _assignToShiftSection(String deptName, String semester, String shift, int sectionLimit, StudentModel student) async {
    final sectionRef = _firestore.collection('departments').doc(deptName)
        .collection('semesters').doc(semester).collection('sections');

    var sectionQuery = await sectionRef.where('shift', isEqualTo: shift).get();

    for (var doc in sectionQuery.docs) {
      var sectionData = doc.data();
      int totalStudents = sectionData['totalStudents'] ?? 0;
      List<dynamic> studentList = sectionData['studentList'] ?? [];

      if (totalStudents < sectionLimit) {
        studentList.add(student.studentRollNo);
        await sectionRef.doc(doc.id).update({
          'totalStudents': totalStudents + 1,
          'studentList': studentList,
        });
        return sectionData['sectionName'];
      }
    }

    return await _createNewSection(deptName, semester, shift, sectionQuery.docs.length + 1, student);
  }

  Future<String> _createNewSection(String deptName, String semester, String shift, int nextSectionIndex, StudentModel student) async {
    final sectionRef = _firestore.collection('departments').doc(deptName)
        .collection('semesters').doc(semester).collection('sections');

    String sectionID = (shift == 'morning') ? 'A$nextSectionIndex' : 'E$nextSectionIndex';
    String sectionName = (shift == 'morning') ? 'Morning A$nextSectionIndex' : 'Evening E$nextSectionIndex';

    await sectionRef.doc(sectionName).set(
      SectionModel(
        sectionID: sectionID,
        sectionName: sectionName,
        shift: shift,
        totalStudents: 1,
        studentList: [student.studentRollNo],
      ).toMap(),
    );

    return sectionName;
  }

  // Future<StudentModel> addStudent(StudentModel student) async {
  //   var ref = _firestore.collection('students').doc(student.studentEmail);
  //   var snapshot = await ref.get();
  //
  //   _auth.createUserWithEmailAndPassword(email: student.studentEmail, password: student.studentCNIC);
  //
  //   if (!snapshot.exists) {
  //     await ref.set(student.toMap());
  //   } else {
  //     throw Exception('Student already exists');
  //   }
  //
  //   return student;
  // }

  @override
  Future<void> deleteStudent(String id) async {
    _firestore.collection('students').doc(id).delete();
  }

  @override
  Future<StudentModel> editStudent(StudentModel student) async {
    var ref = _firestore.collection('students').doc(student.studentEmail);
    var snapshot = await ref.get();

    if (snapshot.exists) {
      await ref.set(student.toMap());
    } else {
      throw Exception('Student not exists');
    }

    return student;
  }

  @override
  Future<List<StudentModel>> allStudents() async {
    final querySnapshot = await _firestore.collection('students').get();
    return querySnapshot.docs
        .map((doc) => StudentModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<List<StudentModel>> getStudentsByDepartment(String deptName) async {
    final querySnapshot = await _firestore.collection('students')
        .where('studentDepartment', isEqualTo: deptName)
        .get();

    return querySnapshot.docs
        .map((doc) => StudentModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<List<StudentModel>> getStudentsBySemester(String deptName, String semester) async {
    final querySnapshot = await _firestore.collection('students')
        .where('studentDepartment',  isEqualTo: deptName)
        .where('studentSemester', isEqualTo: semester)
        .get();

    return querySnapshot.docs
        .map((doc) => StudentModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<void> setSectionLimit(String deptName, String semester, int limit) async {
    final ref = _firestore.collection('departments').doc(deptName).collection('semesters').doc(semester);
    ref.set({
      'sectionLimit': limit
    }, SetOptions(merge: true));

    if (kDebugMode) {
      print('limit set');
    }
  }

}