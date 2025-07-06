import '../../domain/entities/StudentAssignment.dart';

class StudentAssignmentModel extends StudentAssignment {
  StudentAssignmentModel({
    required super.id,
    required super.title,
    required super.description,
    required super.dueDate,
    required super.fileUrl,
    required super.courseId,
    required super.courseName,
    required super.status,
    super.submittedFileUrl,
    super.submittedAt,
  });

  factory StudentAssignmentModel.fromMap(
      Map<String, dynamic> map, String documentId) {
    return StudentAssignmentModel(
      id: documentId,
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'].toDate(),
      fileUrl: map['fileUrl'],
      courseId: map['courseId'],
      courseName: map['courseName'],
      status: map['status'],
      submittedFileUrl: map['submittedFileUrl'],
      submittedAt:
          map['submittedAt'] != null ? map['submittedAt'].toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'fileUrl': fileUrl,
      'courseId': courseId,
      'courseName': courseName,
      'status': status,
      'submittedFileUrl': submittedFileUrl,
      'submittedAt': submittedAt,
    };
  }
}
