import 'package:digital_academic_portal/shared/domain/entities/Query.dart';

class StudentQueryModel extends Query {
  StudentQueryModel({
    required super.id,
    required super.studentID,
    required super.studentName,
    required super.subject,
    required super.message,
    required super.status,
    required super.createdDate,
    super.response,
    super.responseDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentID': studentID,
      'studentName': studentName,
      'subject': subject,
      'message': message,
      'status': status,
      'createdDate': createdDate.toIso8601String(),
      'response': response,
      'responseDate': responseDate?.toIso8601String(),
    };
  }

  StudentQueryModel.fromEntity(Query entity) : super(
    id: entity.id,
    studentID: entity.studentID,
    studentName: entity.studentName,
    subject: entity.subject,
    message: entity.message,
    status: entity.status,
    createdDate: entity.createdDate,
    response: entity.response,
    responseDate: entity.responseDate,
  );

  factory StudentQueryModel.fromMap(Map<String, dynamic> map) {
    return StudentQueryModel(
      id: map['id'] ?? '',
      studentID: map['studentID'] ?? '',
      studentName: map['studentName'] ?? '',
      subject: map['subject'] ?? '',
      message: map['message'] ?? '',
      status: map['status'] ?? '',
      createdDate: DateTime.parse(map['createdDate']),
      response: map['response'],
      responseDate: map['responseDate'] != null
          ? DateTime.parse(map['responseDate'])
          : null,
    );
  }
}
