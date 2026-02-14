import '../../domain/entities/Assignment.dart';

class AssignmentModel extends Assignment {
  AssignmentModel({required super.id, required super.title, required super.description, required super.dueDate, required super.fileUrl, required super.studentAssignments});
  
  factory AssignmentModel.fromMap(Map<String, dynamic> map, String documentId) {
    return AssignmentModel(
      id: documentId,
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'].toDate(),
      fileUrl: map['fileUrl'],
      studentAssignments: map['studentAssignments'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'fileUrl': fileUrl,
      'studentAssignments': studentAssignments,
    };
  }

}
