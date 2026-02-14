
 //create entity for query a query contains id, studentID, studentName subject, message, status, createdDate, response, responseDate
 class Query {
  final String id;
  final String studentID;
  final String studentName;
  final String subject;
  final String message;
  final String status;
  final DateTime createdDate;
  final String? response;
  final DateTime? responseDate;

  Query({
    required this.id, 
    required this.studentID, 
    required this.studentName, 
    required this.subject, 
    required this.message, 
    required this.status, 
    required this.createdDate, 
    this.responseDate, 
    this.response,
  });
 }