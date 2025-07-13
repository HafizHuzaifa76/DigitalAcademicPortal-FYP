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
  });

  factory StudentAssignmentModel.fromMap(Map<String, dynamic> map,
      String documentId, String courseId, String courseName, String studentId) {
    return StudentAssignmentModel(
      id: documentId,
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'].toDate(),
      fileUrl: map['fileUrl'],
      courseId: courseId,
      courseName: courseName,
      status: map['studentAssignments'][studentId] == 'Not Submitted'
          ? 'pending'
          : 'submitted',
      submittedFileUrl: map['studentAssignments'][studentId],
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
    };
  }
}
