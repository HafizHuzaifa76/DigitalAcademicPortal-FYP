import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/SubAdminModel.dart';

class SubAdminRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<SubAdminModel>> fetchSubAdmins() async {
    final snapshot = await _firestore.collection('sub_admins').get();
    return snapshot.docs
        .map((doc) => SubAdminModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> addSubAdmin(SubAdminModel subAdmin) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: subAdmin.email, password: '123456');
    final String displayName = 'sub-admin | ${subAdmin.department} | ';

    await userCredential.user!.updateDisplayName(displayName);
    await _firestore.collection('sub_admins').add(subAdmin.toMap());
  }

  Future<void> deleteSubAdmin(String id) async {
    await _firestore.collection('sub_admins').doc(id).delete();
  }
}
