class StudentReport {
  final String id;
  final String studentRollNo;
  final String message;
  final String? response;

  StudentReport({
    required this.id,
    required this.studentRollNo,
    required this.message,
    this.response,
  });
}
