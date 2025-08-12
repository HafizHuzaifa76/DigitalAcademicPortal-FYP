import '../../domain/entities/AdminReport.dart';

class AdminReportModel extends AdminReport {
  AdminReportModel({
    required String id,
    required String studentRollNo,
    required String message,
    String? response,
  }) : super(
            id: id,
            studentRollNo: studentRollNo,
            message: message,
            response: response);

  factory AdminReportModel.fromMap(String id, Map<String, dynamic> map) {
    return AdminReportModel(
      id: id,
      studentRollNo: map['studentRollNo'] ?? '',
      message: map['message'] ?? '',
      response: map['response'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentRollNo': studentRollNo,
      'message': message,
      'response': response,
    };
  }
}
