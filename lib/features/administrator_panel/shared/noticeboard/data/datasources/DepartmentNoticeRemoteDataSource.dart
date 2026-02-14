import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../shared/data/models/NoticeBoardModel.dart';

abstract class DepartmentNoticeRemoteDataSource {
  Future<NoticeModel> addDepartmentNotice(
      String department, NoticeModel notice);
  Future<NoticeModel> editDepartmentNotice(
      String department, NoticeModel notice);
  Future<void> deleteDepartmentNotice(String department, String noticeID);
  Future<List<NoticeModel>> allDepartmentNotices(String department);
}

class DepartmentNoticeRemoteDataSourceImpl
    implements DepartmentNoticeRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<NoticeModel> addDepartmentNotice(
      String department, NoticeModel notice) async {
    var ref = _firestore
        .collection('departments')
        .doc(department)
        .collection('notices')
        .doc(notice.id);
    var snapshot = await ref.get();
    if (!snapshot.exists) {
      await ref.set(notice.toMap());
    } else {
      throw Exception('Notice already exists');
    }
    return notice;
  }

  @override
  Future<void> deleteDepartmentNotice(
      String department, String noticeID) async {
    await _firestore
        .collection('departments')
        .doc(department)
        .collection('notices')
        .doc(noticeID)
        .delete();
  }

  @override
  Future<NoticeModel> editDepartmentNotice(
      String department, NoticeModel notice) async {
    var ref = _firestore
        .collection('departments')
        .doc(department)
        .collection('notices')
        .doc(notice.id);
    var snapshot = await ref.get();
    if (snapshot.exists) {
      await ref.set(notice.toMap());
    } else {
      throw Exception('Notice does not exist');
    }
    return notice;
  }

  @override
  Future<List<NoticeModel>> allDepartmentNotices(String department) async {
    final querySnapshot = await _firestore
        .collection('departments')
        .doc(department)
        .collection('notices')
        .get();
    return querySnapshot.docs
        .map((doc) => NoticeModel.fromMap(doc.data()))
        .toList()
        .reversed
        .toList();
  }
}
