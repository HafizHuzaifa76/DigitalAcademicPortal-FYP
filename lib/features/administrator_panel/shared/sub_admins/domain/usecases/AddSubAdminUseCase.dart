import '../entities/SubAdmin.dart';
import '../repositories/SubAdminRepository.dart';

class AddSubAdminUseCase {
  final SubAdminRepository repository;
  AddSubAdminUseCase(this.repository);

  Future<void> call(SubAdmin subAdmin) async {
    await repository.addSubAdmin(subAdmin);
  }
}
