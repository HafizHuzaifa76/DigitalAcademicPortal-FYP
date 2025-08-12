class AdminReport {
  final String id;
  final String studentRollNo;
  final String message;
  final String? response;

  AdminReport({
    required this.id,
    required this.studentRollNo,
    required this.message,
    this.response,
  });
}
