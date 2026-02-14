import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_academic_portal/features/student_panel/presentation/pages/StudentDashboardPage.dart';
import '../../../../../../shared/data/models/NoticeBoardModel.dart';

abstract class StudentNoticeRemoteDataSource {
  Future<List<NoticeModel>> allNotices();
}

class StudentNoticeRemoteDataSourceImpl
    implements StudentNoticeRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var student = StudentDashboardPage.studentProfile;

  @override
  Future<List<NoticeModel>> allNotices() async {
    if (student == null) {
      throw Exception('student is null');
    }
    final querySnapshot = await _firestore.collection('notices').get();
    final queryDeptSnapshot = await _firestore
        .collection('departments')
        .doc(student!.studentDepartment)
        .collection('notices')
        .get();

    var notices = querySnapshot.docs
        .map((doc) => NoticeModel.fromMap(doc.data()))
        .toList();

    var deptNotices = queryDeptSnapshot.docs
        .map((doc) => NoticeModel.fromMap(doc.data()))
        .toList();

    var allNotices = notices + deptNotices;

    // Sort by datePosted descending (latest first)
    allNotices.sort((a, b) => b.datePosted.compareTo(a.datePosted));

    return allNotices;
  }
}
