import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../shared/data/models/TeacherModel.dart';

abstract class TeacherPanelRemoteDataSource {
  Future<TeacherModel> getTeacherPanelProfile();
}

class TeacherPanelRemoteDataSourceImpl implements TeacherPanelRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<TeacherModel> getTeacherPanelProfile() async {
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

      final QuerySnapshot teacherSnapshot = await _firestore
          .collection('departments')
          .doc(dept)
          .collection('teachers')
          .where('teacherEmail', isEqualTo: currentUser.email)
          .get();

      if (teacherSnapshot.docs.isEmpty) {
        throw Exception('Teacher not found');
      }

      final t = TeacherModel.fromMap(
          teacherSnapshot.docs.first.data() as Map<String, dynamic>);
      print('teacher');
      print(t.toMap());
      return t;
    } catch (e) {
      throw Exception('Failed to fetch teacher profile: ${e.toString()}');
    }
  }
}
