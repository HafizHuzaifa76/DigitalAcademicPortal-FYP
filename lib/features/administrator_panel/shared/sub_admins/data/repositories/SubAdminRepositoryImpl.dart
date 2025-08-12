import '../../domain/entities/SubAdmin.dart';
import '../../domain/repositories/SubAdminRepository.dart';
import '../datasources/SubAdminRemoteDataSource.dart';
import '../models/SubAdminModel.dart';

class SubAdminRepositoryImpl implements SubAdminRepository {
  final SubAdminRemoteDataSource remoteDataSource;
  SubAdminRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<SubAdmin>> fetchSubAdmins() async {
    return await remoteDataSource.fetchSubAdmins();
  }

  @override
  Future<void> addSubAdmin(SubAdmin subAdmin) async {
    await remoteDataSource.addSubAdmin(SubAdminModel(
      id: subAdmin.id,
      email: subAdmin.email,
      name: subAdmin.name,
      department: subAdmin.department,
    ));
  }

  @override
  Future<void> deleteSubAdmin(String id) async {
    await remoteDataSource.deleteSubAdmin(id);
  }
}
