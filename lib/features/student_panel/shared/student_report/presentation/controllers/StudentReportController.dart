import 'package:get/get.dart';
import '../../domain/entities/StudentReport.dart';
import '../../domain/usecases/SubmitStudentReportUseCase.dart';
import '../../domain/usecases/GetStudentReportsUseCase.dart';

class StudentReportController extends GetxController {
  final SubmitStudentReportUseCase submitUseCase;
  final GetStudentReportsUseCase getReportsUseCase;
  final String studentRollNo;

  StudentReportController({
    required this.submitUseCase,
    required this.getReportsUseCase,
    required this.studentRollNo,
  });

  var message = ''.obs;
  var isLoading = false.obs;
  var reports = <StudentReport>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchReports();
  }

  Future<void> fetchReports() async {
    isLoading.value = true;
    try {
      final result = await getReportsUseCase(studentRollNo);
      reports.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitReport() async {
    if (message.value.trim().isEmpty) return;
    isLoading.value = true;
    final report = StudentReport(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      studentRollNo: studentRollNo,
      message: message.value.trim(),
      response: null,
    );
    try {
      await submitUseCase(report);
      message.value = '';
      await fetchReports();
    } finally {
      isLoading.value = false;
    }
  }
}
