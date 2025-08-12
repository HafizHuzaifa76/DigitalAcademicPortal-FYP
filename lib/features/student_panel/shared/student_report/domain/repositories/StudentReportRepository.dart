import '../entities/StudentReport.dart';

abstract class StudentReportRepository {
  Future<void> submitReport(StudentReport report);
  Future<List<StudentReport>> getReportsForStudent(String studentRollNo);
}
