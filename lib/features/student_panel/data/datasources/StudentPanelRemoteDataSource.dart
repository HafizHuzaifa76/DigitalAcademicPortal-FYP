import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_academic_portal/shared/data/models/StudentModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class StudentPanelRemoteDataSource {
  Future<StudentModel> getStudentPanelProfile();
}

class StudentPanelRemoteDataSourceImpl implements StudentPanelRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<StudentModel> getStudentPanelProfile() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }
      String displayName = currentUser.displayName ?? '';

      List<String> parts = displayName.split(' | ');
      if (parts.length < 2) {
        throw Exception('Display name not formatted');
      }
      String dept = parts[1];
      print('dept: $dept');

      final QuerySnapshot studentSnapshot = await _firestore
          .collection('departments')
          .doc(dept)
          .collection('students')
          .where('studentEmail', isEqualTo: currentUser.email)
          .get();

      if (studentSnapshot.docs.isEmpty) {
        throw Exception('Student not found');
      }

      return StudentModel.fromMap(studentSnapshot.docs.first.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch Student profile: ${e.toString()}');
    }
  }
}
