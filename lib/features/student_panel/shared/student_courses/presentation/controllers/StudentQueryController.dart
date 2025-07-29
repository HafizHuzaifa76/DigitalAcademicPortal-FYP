import 'package:get/get.dart';
import 'package:digital_academic_portal/shared/domain/entities/Query.dart';
import '../../domain/usecases/GetStudentQueriesUseCase.dart';
import '../../domain/usecases/AskStudentQueryUseCase.dart';

class StudentQueryController extends GetxController {
  final GetStudentQueriesUseCase getQueriesUseCase;
  final AskStudentQueryUseCase askQueryUseCase;
  StudentQueryController(
      {required this.getQueriesUseCase, required this.askQueryUseCase});

  final queries = <Query>[].obs;
  final isLoading = false.obs;

  List<Query> get pendingQueries =>
      queries.where((q) => q.status == 'pending').toList();
  List<Query> get respondedQueries =>
      queries.where((q) => q.status == 'responded').toList();

  Future<void> fetchQueries(
      String dept, String semester, String course, String section) async {
    isLoading.value = true;
    try {
      final result = await getQueriesUseCase(dept, semester, course, section);
      queries.value = result;
    } catch (e) {
      queries.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> askQuery(Query query, String dept, String semester,
      String course, String section) async {
    await askQueryUseCase(query, dept, semester, course, section);
    await fetchQueries(dept, semester, course, section);
  }
}
