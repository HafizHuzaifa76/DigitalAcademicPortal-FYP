import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/AdminReportModel.dart';

class AdminReportRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AdminReportModel>> fetchUnrespondedReports() async {
    final snapshot = await _firestore
        .collection('reports')
        .doc('report')
        .collection('items')
        .where('response', isNull: true)
        .get();
    return snapshot.docs
        .map((doc) => AdminReportModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> respondToReport(String reportId, String response) async {
    await _firestore
        .collection('reports')
        .doc('report')
        .collection('items')
        .doc(reportId)
        .update({'response': response});
  }
}
