import '../../domain/entities/Teacher.dart';

class TeacherModel extends Teacher{
  TeacherModel({required super.teacherName, required super.teacherDept, required super.teacherEmail, required super.teacherCNIC, required super.teacherContact, required super.teacherAddress, required super.teacherType, required super.teacherGender});


  Map<String, dynamic> toMap() {
    return {
      'teacherName': teacherName,
      'teacherDept': teacherDept,
      'teacherEmail': teacherEmail,
      'teacherCNIC': teacherCNIC,
      'teacherContact': teacherContact,
      'teacherAddress': teacherAddress,
      'teacherType': teacherType,
      'teacherGender': teacherGender,
    };
  }

  factory TeacherModel.fromTeacher(Teacher teacher){
    return TeacherModel(
        teacherName: teacher.teacherName,
        teacherDept: teacher.teacherDept,
        teacherEmail: teacher.teacherEmail,
        teacherCNIC: teacher.teacherCNIC,
        teacherContact: teacher.teacherContact,
        teacherAddress: teacher.teacherAddress,
        teacherType: teacher.teacherType,
        teacherGender: teacher.teacherGender,
    );
  }
  factory TeacherModel.fromMap(Map<String, dynamic> map) {
    return TeacherModel(
      teacherName: map['teacherName'] as String,
      teacherDept: map['teacherDept'] as String,
      teacherEmail: map['teacherEmail'] as String,
      teacherCNIC: map['teacherCNIC'] as String,
      teacherContact: map['teacherContact'] as String,
      teacherAddress: map['teacherAddress'] as String,
      teacherType: map['teacherType'] as String,
      teacherGender: map['teacherGender'] as String,
    );
  }
}