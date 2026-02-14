
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/TemplateModel.dart';


abstract class TemplateRemoteDataSource{
  Future<TemplateModel> addTemplate(TemplateModel notice);
  Future<TemplateModel> editTemplate(TemplateModel notice);
  Future<void> deleteTemplate(String noticeID);
  Future<List<TemplateModel>> allTemplates();
}

class TemplateRemoteDataSourceImpl implements TemplateRemoteDataSource{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<TemplateModel> addTemplate(TemplateModel notice) async {
    var ref = _firestore.collection('notices').doc(notice.id);
    var snapshot = await ref.get();

    if (!snapshot.exists) {
      await ref.set(notice.toMap());
    } else {
      throw Exception('Template already exists');
    }

    return notice;
  }

  @override
  Future<void> deleteTemplate(String noticeID) async {
    _firestore.collection('notices').doc(noticeID).delete();
  }

  @override
  Future<TemplateModel> editTemplate(TemplateModel notice) async {
    var ref = _firestore.collection('notices').doc(notice.id);
    var snapshot = await ref.get();

    if (snapshot.exists) {
      await ref.set(notice.toMap());
    } else {
      throw Exception('Template not exists');
    }

    return notice;
  }

  @override
  Future<List<TemplateModel>> allTemplates() async {
    final querySnapshot = await _firestore.collection('notices').get();
    return querySnapshot.docs
        .map((doc) => TemplateModel.fromMap(doc.data()))
        .toList();
  }

}