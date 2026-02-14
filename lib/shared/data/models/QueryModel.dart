
import '../../domain/entities/Query.dart';

class QueryModel extends Query {
  QueryModel({
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

  factory QueryModel.fromMap(Map<String, dynamic> map) {
    return QueryModel(
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

  QueryModel.fromEntity(Query entity) : super(
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

  QueryModel copyWith({
    String? id,
    String? studentID,
    String? studentName,
    String? subject,
    String? message,
    String? status,
    DateTime? createdDate,
    String? response,
    DateTime? responseDate,
  }) {
    return QueryModel(
      id: id ?? this.id,
      studentID: studentID ?? this.studentID,
      studentName: studentName ?? this.studentName,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      status: status ?? this.status,
      createdDate: createdDate ?? this.createdDate,
      response: response ?? this.response,
      responseDate: responseDate ?? this.responseDate,
    );
  }
}