import '../../domain/entities/Assignment.dart';

class AssignmentModel extends Assignment {
  AssignmentModel({
    required String id,
    required String title,
    required String description,
    required DateTime dueDate,
    required String fileUrl,
  }) : super(
          id: id,
          title: title,
          description: description,
          dueDate: dueDate,
          fileUrl: fileUrl,
        );

  factory AssignmentModel.fromMap(Map<String, dynamic> map, String documentId) {
    return AssignmentModel(
      id: documentId,
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'].toDate(),
      fileUrl: map['fileUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'fileUrl': fileUrl,
    };
  }
}
