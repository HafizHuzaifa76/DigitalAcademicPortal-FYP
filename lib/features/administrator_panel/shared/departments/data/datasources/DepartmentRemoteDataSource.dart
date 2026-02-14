import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/departments/data/models/SemesterModel.dart';
import '../models/DepartmentModel.dart';

abstract class DepartmentRemoteDataSource {
  Future<DepartmentModel> addDepartment(DepartmentModel department);
  Future<DepartmentModel> editDepartment(DepartmentModel department);
  Future<void> deleteDepartment(String departmentName);
  Future<List<DepartmentModel>> allDepartments();
  Future<List<SemesterModel>> getAllSemesters(String departmentName);
  Future<SemesterModel> updateSemester(
      String departmentName, SemesterModel semester);
}

class DepartmentRemoteDataSourceImpl implements DepartmentRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<DepartmentModel> addDepartment(DepartmentModel department) async {
    var ref =
        _firestore.collection('departments').doc(department.departmentName);
    var snapshot = await ref.get();

    if (!snapshot.exists) {
      await ref.set(department.toMap());

      // Create semesters in Roman numerals
      for (int i = 1; i <= department.totalSemesters; i++) {
        String semesterName = "SEM-${Utils().toRomanNumeral(i)}";
        var semester = SemesterModel(
          semesterName: semesterName,
          sectionLimit: 0,
          totalCourses: 0,
          numOfCourses: 0,
          numOfSections: 0,
          numOfStudents: 0,
          numOfElectiveCourses: 0,
        );
        await ref
            .collection('semesters')
            .doc(semesterName)
            .set(semester.toMap());
      }
    } else {
      throw Exception('Department already exists');
    }

    return department;
  }

  @override
  Future<void> deleteDepartment(String departmentName) async {
    _firestore.collection('departments').doc(departmentName).delete();
  }

  @override
  Future<DepartmentModel> editDepartment(DepartmentModel department) async {
    var ref =
        _firestore.collection('departments').doc(department.departmentName);
    var snapshot = await ref.get();

    if (snapshot.exists) {
      await ref.set(department.toMap());
    } else {
      throw Exception('Department not exists');
    }

    return department;
  }

  @override
  Future<List<DepartmentModel>> allDepartments() async {
    final deptRef = _firestore.collection('departments');
    final querySnapshot = await deptRef.get();

    // Use Future.wait to run student counting for each department in parallel
    final departments = await Future.wait(querySnapshot.docs.map((doc) async {
      final departmentName = doc.data()['departmentName'] as String;

      // Get count of students and teachers in the department
      final studentRef = deptRef.doc(departmentName).collection('students');
      final studentSnapshot = await studentRef.get();
      final studentCount = studentSnapshot.size;

      final teacherRef = deptRef.doc(departmentName).collection('teachers');
      final teacherSnapshot = await teacherRef.get();
      final teacherCount = teacherSnapshot.size;

      // Pass count into fromMap (assuming you modified fromMap to accept it)
      return DepartmentModel.fromMap(
          doc.data(), doc.id, studentCount, teacherCount);
    }));

    return departments;
  }

  @override
Future<List<SemesterModel>> getAllSemesters(String departmentName) async {
  final ref = _firestore
      .collection('departments')
      .doc(departmentName)
      .collection('semesters');

  final snapshot = await ref.get();

  if (snapshot.docs.isEmpty) {
    throw Exception('No semesters found for this department');
  }

  // Use Future.wait to count sections in parallel
  final semesters = await Future.wait(snapshot.docs.map((doc) async {
    final semesterName = doc.data()['semesterName'] as String;

    // Reference to sections collection
    final secRef = ref.doc(semesterName).collection('sections');
    final secSnapshot = await secRef.get();
    final sectionCount = secSnapshot.size;

    final studentRef = _firestore
      .collection('departments')
      .doc(departmentName).collection('students');
    final studentSnapshot = await studentRef.where('studentSemester', isEqualTo: semesterName).get();
    final studentCount = studentSnapshot.size;

    // Assuming SemesterModel.fromMap accepts sectionCount now
    return SemesterModel.fromMap(doc.data(), sectionCount, studentCount);
  }));

  return semesters;
}

  @override
  Future<SemesterModel> updateSemester(
      String departmentName, SemesterModel semester) async {
    var ref = _firestore
        .collection('departments')
        .doc(departmentName)
        .collection('semesters')
        .doc(semester.semesterName);
    var snapshot = await ref.get();
    if (snapshot.exists) {
      print(departmentName);
      print(semester.numOfElectiveCourses);
      print(semester.totalCourses);
      print(semester.semesterName);
      await ref.set(semester.toMap());
      return semester;
    } else {
      throw Exception('Department not exists');
    }
  }
}
