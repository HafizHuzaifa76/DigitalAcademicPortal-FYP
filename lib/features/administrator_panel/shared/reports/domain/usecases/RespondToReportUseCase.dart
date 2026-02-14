import '../repositories/AdminReportRepository.dart';

class RespondToReportUseCase {
  final AdminReportRepository repository;
  RespondToReportUseCase(this.repository);

  Future<void> call(String reportId, String response) async {
    await repository.respondToReport(reportId, response);
  }
}
