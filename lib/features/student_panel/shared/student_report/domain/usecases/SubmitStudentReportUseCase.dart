import '../entities/StudentReport.dart';
import '../repositories/StudentReportRepository.dart';

class SubmitStudentReportUseCase {
  final StudentReportRepository repository;
  SubmitStudentReportUseCase(this.repository);

  Future<void> call(StudentReport report) async {
    await repository.submitReport(report);
  }
}
