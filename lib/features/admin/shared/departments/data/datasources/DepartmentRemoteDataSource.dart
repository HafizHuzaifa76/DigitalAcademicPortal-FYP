
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:digital_academic_portal/features/admin/shared/departments/data/models/SemesterModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/DepartmentModel.dart';

abstract class DepartmentRemoteDataSource{
  Future<DepartmentModel> addDepartment(DepartmentModel department);
  Future<DepartmentModel> editDepartment(DepartmentModel department);
  Future<void> deleteDepartment(String departmentName);
  Future<List<DepartmentModel>> allDepartments();
  Future<List<SemesterModel>> getAllSemesters(String departmentName);
}

class DepartmentRemoteDataSourceImpl implements DepartmentRemoteDataSource{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<DepartmentModel> addDepartment(DepartmentModel department) async {
    var ref = _firestore.collection('departments').doc(department.departmentName);
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
            numOfTeachers: 0,
            numOfStudents: 0,
            numOfElectiveCourses: 0,
        );
        await ref.collection('semesters').doc(semesterName).set(semester.toMap());
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
    var ref = _firestore.collection('departments').doc(department.departmentName);
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
    final querySnapshot = await _firestore.collection('departments').get();
    return querySnapshot.docs
        .map((doc) => DepartmentModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<List<SemesterModel>> getAllSemesters(String departmentName) async {
    var ref = _firestore.collection('departments').doc(departmentName).collection('semesters');
    var snapshot = await ref.get();

    if (snapshot.docs.isNotEmpty) {
      // Map over the documents and extract semester names
      return snapshot.docs.map((doc) => SemesterModel.fromMap(doc.data())).toList();
    } else {
      throw Exception('No semesters found for this department');
    }
  }

}