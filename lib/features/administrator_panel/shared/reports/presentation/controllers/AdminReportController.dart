import 'package:get/get.dart';
import '../../domain/entities/AdminReport.dart';
import '../../domain/usecases/FetchUnrespondedReportsUseCase.dart';
import '../../domain/usecases/RespondToReportUseCase.dart';

class AdminReportController extends GetxController {
  final FetchUnrespondedReportsUseCase fetchUnrespondedReportsUseCase;
  final RespondToReportUseCase respondToReportUseCase;

  var reports = <AdminReport>[].obs;
  var isLoading = false.obs;

  AdminReportController({
    required this.fetchUnrespondedReportsUseCase,
    required this.respondToReportUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  Future<void> loadReports() async {
    isLoading.value = true;
    try {
      final result = await fetchUnrespondedReportsUseCase();
      reports.value = result;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> respondToReport(String reportId, String response) async {
    await respondToReportUseCase(reportId, response);
    await loadReports();
  }
}
