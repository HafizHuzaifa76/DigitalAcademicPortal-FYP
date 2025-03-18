import '../../domain/entities/Section.dart';

class SectionModel extends Section{
  SectionModel({required super.sectionID, required super.sectionName, required super.shift, required super.totalStudents, required super.studentList});

  factory SectionModel.fromSection(Section section){
    return SectionModel(
        sectionID: section.sectionID,
        sectionName: section.sectionName,
        shift: section.shift,
        totalStudents: section.totalStudents,
        studentList: section.studentList
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sectionID': sectionID,
      'sectionName': sectionName,
      'shift': shift,
      'totalStudents': totalStudents,
      'studentList': studentList,
    };
  }

  factory SectionModel.fromMap(Map<String, dynamic> map) {
    return SectionModel(
      sectionID: map['sectionID'] ?? map['sectionName'] as String,
      sectionName: map['sectionName'] as String,
      shift: map['shift'] as String,
      totalStudents: map['totalStudents'] as int,
      studentList: map['studentList'] as List,
    );
  }
}