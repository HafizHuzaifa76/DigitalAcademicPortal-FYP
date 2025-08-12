import 'package:get/get.dart';
import '../../data/datasources/StudentReportRemoteDataSource.dart';
import '../../data/repositories/StudentReportRepositoryImpl.dart';
import '../../domain/usecases/SubmitStudentReportUseCase.dart';
import '../../domain/usecases/GetStudentReportsUseCase.dart';
import '../controllers/StudentReportController.dart';
import '../../../../presentation/pages/StudentDashboardPage.dart';

class StudentReportBindings extends Bindings {
  @override
  void dependencies() {
    // Normally, inject real dependencies here
    final remoteDataSource = StudentReportRemoteDataSourceImpl();
    final repository =
        StudentReportRepositoryImpl(remoteDataSource: remoteDataSource);
    final submitUseCase = SubmitStudentReportUseCase(repository);
    final getReportsUseCase = GetStudentReportsUseCase(repository);
    final studentRollNo =
        StudentDashboardPage.studentProfile?.studentRollNo ?? '';
    Get.lazyPut(() => StudentReportController(
          submitUseCase: submitUseCase,
          getReportsUseCase: getReportsUseCase,
          studentRollNo: studentRollNo,
        ));
  }
}
