import '../repositories/SubAdminRepository.dart';

class DeleteSubAdminUseCase {
  final SubAdminRepository repository;
  DeleteSubAdminUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteSubAdmin(id);
  }
}
