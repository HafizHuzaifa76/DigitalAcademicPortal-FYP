
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../shared/data/models/NoticeBoardModel.dart';


abstract class StudentNoticeRemoteDataSource{
  Future<List<NoticeModel>> allNotices();
}

class StudentNoticeRemoteDataSourceImpl implements StudentNoticeRemoteDataSource{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<NoticeModel>> allNotices() async {
    final querySnapshot = await _firestore.collection('notices').get();
    return querySnapshot.docs
        .map((doc) => NoticeModel.fromMap(doc.data()))
        .toList().reversed.toList();
  }

}