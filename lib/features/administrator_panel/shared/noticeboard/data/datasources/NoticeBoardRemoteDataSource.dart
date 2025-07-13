import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../../shared/data/models/NoticeBoardModel.dart';

abstract class NoticeRemoteDataSource {
  Future<NoticeModel> addNotice(NoticeModel notice);
  Future<NoticeModel> editNotice(NoticeModel notice);
  Future<void> deleteNotice(String noticeID);
  Future<List<NoticeModel>> allNotices();
}

class NoticeRemoteDataSourceImpl implements NoticeRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<NoticeModel> addNotice(NoticeModel notice) async {
    var ref = _firestore.collection('notices').doc(notice.id);
    var snapshot = await ref.get();

    if (!snapshot.exists) {
      await ref.set(notice.toMap());
    } else {
      throw Exception('Notice already exists');
    }

    return notice;
  }

  @override
  Future<void> deleteNotice(String noticeID) async {
    _firestore.collection('notices').doc(noticeID).delete();
  }

  @override
  Future<NoticeModel> editNotice(NoticeModel notice) async {
    var ref = _firestore.collection('notices').doc(notice.id);
    var snapshot = await ref.get();

    if (snapshot.exists) {
      await ref.set(notice.toMap());
    } else {
      throw Exception('Notice not exists');
    }

    return notice;
  }

  @override
  Future<List<NoticeModel>> allNotices() async {
    final querySnapshot = await _firestore.collection('notices').get();
    return querySnapshot.docs
        .map((doc) => NoticeModel.fromMap(doc.data()))
        .toList()
        .reversed
        .toList();
  }
}
