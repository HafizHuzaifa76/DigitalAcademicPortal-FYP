
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/TemplateModel.dart';

abstract class TemplateRemoteDataSource{
  Future<TemplateModel> addTemplate(TemplateModel department);
  Future<TemplateModel> editTemplate(TemplateModel department);
  Future<void> deleteTemplate(String departmentName);
  Future<List<TemplateModel>> allTemplates();
}

class TemplateRemoteDataSourceImpl implements TemplateRemoteDataSource{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<TemplateModel> addTemplate(TemplateModel Template) async {
    var ref = _firestore.collection('Templates').doc('id');
    var snapshot = await ref.get();

    if (!snapshot.exists) {
      await ref.set(Template.toMap());
    } else {
      throw Exception('Template already exists');
    }

    return Template;
  }

  @override
  Future<void> deleteTemplate(String TemplateName) async {
    _firestore.collection('Templates').doc(TemplateName).delete();
  }

  @override
  Future<TemplateModel> editTemplate(TemplateModel Template) async {
    var ref = _firestore.collection('Templates').doc('Template');
    var snapshot = await ref.get();

    if (snapshot.exists) {
      await ref.set(Template.toMap());
    } else {
      throw Exception('Template not exists');
    }

    return Template;
  }

  @override
  Future<List<TemplateModel>> allTemplates() async {
    final querySnapshot = await _firestore.collection('Templates').get();
    return querySnapshot.docs
        .map((doc) => TemplateModel.fromMap(doc.data()))
        .toList();
  }

}