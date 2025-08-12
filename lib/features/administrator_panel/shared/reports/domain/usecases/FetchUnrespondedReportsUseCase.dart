import '../entities/AdminReport.dart';
import '../repositories/AdminReportRepository.dart';

class FetchUnrespondedReportsUseCase {
  final AdminReportRepository repository;
  FetchUnrespondedReportsUseCase(this.repository);

  Future<List<AdminReport>> call() async {
    return await repository.fetchUnrespondedReports();
  }
}
