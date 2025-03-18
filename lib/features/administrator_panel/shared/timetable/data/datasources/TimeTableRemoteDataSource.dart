
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/TimeTableEntryModel.dart';


abstract class TimeTableRemoteDataSource{
  Future<TimeTableEntryModel> addTimeTable(TimeTableEntryModel timeTable);
  Future<TimeTableEntryModel> editTimeTable(TimeTableEntryModel timeTable);
  Future<void> deleteTimeTable(String timeTableID);
  Future<List<TimeTableEntryModel>> allTimeTables();
}

class TimeTableRemoteDataSourceImpl implements TimeTableRemoteDataSource{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<TimeTableEntryModel> addTimeTable(TimeTableEntryModel timeTable) async {
    var ref = _firestore.collection('TimeTables').doc(timeTable.id);
    var snapshot = await ref.get();

    if (!snapshot.exists) {
      await ref.set(timeTable.toMap());
    } else {
      throw Exception('TimeTable already exists');
    }

    return timeTable;
  }

  @override
  Future<void> deleteTimeTable(String timeTableID) async {
    _firestore.collection('TimeTables').doc(timeTableID).delete();
  }

  @override
  Future<TimeTableEntryModel> editTimeTable(TimeTableEntryModel timeTable) async {
    var ref = _firestore.collection('TimeTables').doc(timeTable.id);
    var snapshot = await ref.get();

    if (snapshot.exists) {
      await ref.set(timeTable.toMap());
    } else {
      throw Exception('TimeTable not exists');
    }

    return timeTable;
  }

  @override
  Future<List<TimeTableEntryModel>> allTimeTables() async {
    final querySnapshot = await _firestore.collection('TimeTables').get();
    return querySnapshot.docs
        .map((doc) => TimeTableEntryModel.fromMap(doc.data()))
        .toList();
  }

}