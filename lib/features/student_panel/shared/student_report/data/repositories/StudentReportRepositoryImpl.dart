import '../../domain/entities/StudentReport.dart';
import '../../domain/repositories/StudentReportRepository.dart';
import '../datasources/StudentReportRemoteDataSource.dart';
import '../models/StudentReportModel.dart';

class StudentReportRepositoryImpl implements StudentReportRepository {
  final StudentReportRemoteDataSource remoteDataSource;
  StudentReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> submitReport(StudentReport report) async {
    await remoteDataSource.submitReport(StudentReportModel(
      id: report.id,
      studentRollNo: report.studentRollNo,
      message: report.message,
      response: report.response,
    ));
  }

  @override
  Future<List<StudentReport>> getReportsForStudent(String studentRollNo) async {
    return await remoteDataSource.getReportsForStudent(studentRollNo);
  }
}
