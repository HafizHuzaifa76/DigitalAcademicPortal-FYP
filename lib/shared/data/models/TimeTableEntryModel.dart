import '../../domain/entities/TimeTable.dart';

class TimeTableEntryModel extends TimeTableEntry{
  TimeTableEntryModel({ required super.id, required super.courseCode, required super.courseName, required super.room, required super.timeSlot, required super.day, required super.section, required super.teacherName, required super.teacherCNIC, required super.semester});

  factory TimeTableEntryModel.fromTimeTable(TimeTableEntry timeTable){
    return TimeTableEntryModel(
        id: timeTable.id,
        courseCode: timeTable.courseCode,
        courseName: timeTable.courseName,
        room: timeTable.room,
        timeSlot: timeTable.timeSlot,
        day: timeTable.day,
        section: timeTable.section,
        teacherName: timeTable.teacherName,
        teacherCNIC: timeTable.teacherCNIC,
        semester: timeTable.semester
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseCode': courseCode,
      'courseName': courseName,
      'teacherName': teacherName,
      'teacherCNIC': teacherCNIC,
      'room': room,
      'timeSlot': timeSlot,
      'day': day,
      'section': section,
      'semester': semester,
    };
  }

  factory TimeTableEntryModel.fromMap(String id, Map<String, dynamic> map) {
    return TimeTableEntryModel(
      id: id,
      courseCode: map['courseCode'] as String,
      courseName: map['courseName'] as String,
      teacherName: map['teacherName'] as String,
      teacherCNIC: map['teacherCNIC'] as String,
      room: map['room'] as String,
      timeSlot: map['timeSlot'] as String,
      day: map['day'] as String,
      section: map['section'] as String,
      semester: map['semester'] as String,
    );
  }
}