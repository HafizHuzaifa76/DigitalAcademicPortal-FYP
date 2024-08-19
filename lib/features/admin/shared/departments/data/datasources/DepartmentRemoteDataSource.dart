
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/DepartmentModel.dart';

abstract class DepartmentRemoteDataSource{
  Future<DepartmentModel> addDepartment(DepartmentModel department);
  Future<DepartmentModel> editDepartment(DepartmentModel department);
  Future<void> deleteDepartment(String departmentName);
  Future<List<DepartmentModel>> allDepartments();
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
        .map((doc) => DepartmentModel.fromMap(doc.data()))
        .toList();
  }

}