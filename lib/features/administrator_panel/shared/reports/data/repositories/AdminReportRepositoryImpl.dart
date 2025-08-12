import '../../domain/entities/AdminReport.dart';
import '../../domain/repositories/AdminReportRepository.dart';
import '../datasources/AdminReportRemoteDataSource.dart';

class AdminReportRepositoryImpl implements AdminReportRepository {
  final AdminReportRemoteDataSource remoteDataSource;
  AdminReportRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<AdminReport>> fetchUnrespondedReports() async {
    return await remoteDataSource.fetchUnrespondedReports();
  }

  @override
  Future<void> respondToReport(String reportId, String response) async {
    await remoteDataSource.respondToReport(reportId, response);
  }
}
