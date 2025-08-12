import '../../domain/entities/StudentReport.dart';

class StudentReportModel extends StudentReport {
  StudentReportModel({
    required super.id,
    required super.studentRollNo,
    required super.message,
    super.response,
  });

  factory StudentReportModel.fromMap(Map<String, dynamic> map) {
    return StudentReportModel(
      id: map['id'] as String,
      studentRollNo: map['studentRollNo'] as String,
      message: map['message'] as String,
      response: map['response'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentRollNo': studentRollNo,
      'message': message,
      'response': response,
    };
  }
}
