
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../shared/domain/entities/TimeTable.dart';
import '../../../../../../shared/data/models/TimeTableEntryModel.dart';


abstract class TimeTableRemoteDataSource{
  Future<void> addTimeTable(List<TimeTableEntry> timeTable, String deptName, String semester);
  Future<TimeTableEntryModel> editTimeTable(TimeTableEntryModel timeTable, String deptName, String semester);
  Future<void> deleteTimeTable(String timeTableID, String deptName, String semester);
  Future<List<TimeTableEntryModel>> allTimeTables(String deptName, String semester);
}

class TimeTableRemoteDataSourceImpl implements TimeTableRemoteDataSource{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addTimeTable(List<TimeTableEntry> timeTable, String deptName, String semester) async {
    for(var entry in timeTable) {
      var entryModel = TimeTableEntryModel.fromTimeTable(entry);
      var ref = _firestore.collection('departments').doc(deptName).collection('semesters').doc(semester).collection('timetable');
      await ref.add(entryModel.toMap());
    }
  }

  @override
  Future<void> deleteTimeTable(String timeTableID, String deptName, String semester) async {
    var ref = _firestore.collection('departments').doc(deptName).collection('semesters').doc(semester).collection('timetable').doc(timeTableID);
    ref.delete();
  }

  @override
  Future<TimeTableEntryModel> editTimeTable(TimeTableEntryModel timeTable, String deptName, String semester) async {
    var ref = _firestore.collection('departments').doc(deptName).collection('semesters').doc(semester).collection('timetable').doc(timeTable.id);
    var snapshot = await ref.get();

    if (snapshot.exists) {
      await ref.set(timeTable.toMap());
    } else {
      throw Exception('TimeTable not exists');
    }

    return timeTable;
  }

  @override
  Future<List<TimeTableEntryModel>> allTimeTables(String deptName, String semester) async {
    var ref = _firestore.collection('departments').doc(deptName).collection('semesters').doc(semester).collection('timetable');
    final querySnapshot = await ref.get();
    return querySnapshot.docs
        .map((doc) => TimeTableEntryModel.fromMap(doc.id, doc.data())).toList();
  }

}