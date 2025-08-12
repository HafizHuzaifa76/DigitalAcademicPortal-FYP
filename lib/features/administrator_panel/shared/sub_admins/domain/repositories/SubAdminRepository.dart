import '../entities/SubAdmin.dart';

abstract class SubAdminRepository {
  Future<List<SubAdmin>> fetchSubAdmins();
  Future<void> addSubAdmin(SubAdmin subAdmin);
  Future<void> deleteSubAdmin(String id);
}
