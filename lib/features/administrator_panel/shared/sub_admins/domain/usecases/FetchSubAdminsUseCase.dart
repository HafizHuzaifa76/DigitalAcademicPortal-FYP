import '../entities/SubAdmin.dart';
import '../repositories/SubAdminRepository.dart';

class FetchSubAdminsUseCase {
  final SubAdminRepository repository;
  FetchSubAdminsUseCase(this.repository);

  Future<List<SubAdmin>> call() async {
    return await repository.fetchSubAdmins();
  }
}
