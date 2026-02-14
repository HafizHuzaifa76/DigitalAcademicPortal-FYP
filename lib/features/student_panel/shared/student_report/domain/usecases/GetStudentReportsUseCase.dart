import '../entities/StudentReport.dart';
import '../repositories/StudentReportRepository.dart';

class GetStudentReportsUseCase {
  final StudentReportRepository repository;
  GetStudentReportsUseCase(this.repository);

  Future<List<StudentReport>> call(String studentRollNo) async {
    return await repository.getReportsForStudent(studentRollNo);
  }
}
