import '../entities/AdminReport.dart';

abstract class AdminReportRepository {
  Future<List<AdminReport>> fetchUnrespondedReports();
  Future<void> respondToReport(String reportId, String response);
}
