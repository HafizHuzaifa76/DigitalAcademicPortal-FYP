import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../domain/entities/SubAdmin.dart';
import '../../domain/usecases/FetchSubAdminsUseCase.dart';
import '../../domain/usecases/AddSubAdminUseCase.dart';
import '../../domain/usecases/DeleteSubAdminUseCase.dart';

class SubAdminController extends GetxController {
  final FetchSubAdminsUseCase fetchSubAdminsUseCase;
  final AddSubAdminUseCase addSubAdminUseCase;
  final DeleteSubAdminUseCase deleteSubAdminUseCase;

  var subAdmins = <SubAdmin>[].obs;
  var departments = <String>[].obs;
  var isLoading = false.obs;

  SubAdminController({
    required this.fetchSubAdminsUseCase,
    required this.addSubAdminUseCase,
    required this.deleteSubAdminUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    loadSubAdmins();
  }

  Future<void> loadSubAdmins() async {
    isLoading.value = true;
    try {
      final result = await fetchSubAdminsUseCase();
      subAdmins.value = result;
      final snapshot =
          await FirebaseFirestore.instance.collection('departments').get();

      departments.value =
          snapshot.docs.map((doc) => doc['departmentName'] as String).toList();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addSubAdmin(SubAdmin subAdmin) async {
    await addSubAdminUseCase(subAdmin);
    await loadSubAdmins();
  }

  Future<void> deleteSubAdmin(String id) async {
    await deleteSubAdminUseCase(id);
    await loadSubAdmins();
  }
}
