import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:get/get.dart';
import '../../domain/entities/TeacherCourse.dart';
import '../../domain/usecases/FetchAllTeacherCoursesUseCase.dart';
import '../../domain/usecases/GetStudentNamesUseCase.dart';
import '../../domain/usecases/GetQueriesUseCase.dart';
import '../../domain/usecases/RespondToQueryUseCase.dart';
import '../../../../../../shared/domain/entities/Query.dart';

class TeacherCourseController extends GetxController {
  final FetchAllTeacherCoursesUseCase fetchAllTeacherCourses;
  final GetStudentNamesUseCase getStudentNamesUseCase;
  final GetQueriesUseCase getQueriesUseCase;
  final RespondToQueryUseCase respondToQueryUseCase;

  final RxList<TeacherCourse> coursesList = <TeacherCourse>[].obs;
  TeacherCourse? selectedCourse;
  final RxBool isLoading = false.obs;
  final RxMap<String, String> studentNames = <String, String>{}.obs;
  final RxBool isLoadingStudentNames = false.obs;

  // Query related variables
  final RxList<Query> allQueries = <Query>[].obs;
  final RxList<Query> pendingQueries = <Query>[].obs;
  final RxList<Query> respondedQueries = <Query>[].obs;
  final RxBool isLoadingQueries = false.obs;

  TeacherCourseController({
    required this.fetchAllTeacherCourses,
    required this.getStudentNamesUseCase,
    required this.getQueriesUseCase,
    required this.respondToQueryUseCase,
  });

  Future<void> getTeacherCourses(String teacherDept) async {
    isLoading.value = true;
    final result = await fetchAllTeacherCourses.execute(teacherDept);
    result.fold(
      (failure) {
        Utils().showErrorSnackBar('Error', failure.failure.toString());
        isLoading.value = false;
      },
      (courses) {
        coursesList.value = courses;
        print('courses length: ${courses.length}');
        isLoading.value = false;
      },
    );
  }

  Future<void> fetchStudentNames(
      List<dynamic> studentIds, String courseDepartment) async {
    if (studentIds.isEmpty) return;

    isLoadingStudentNames.value = true;
    final params = GetStudentNamesParams(
      studentIds: studentIds,
      courseDepartment: courseDepartment,
    );

    final result = await getStudentNamesUseCase.execute(params);
    result.fold(
      (failure) {
        Utils().showErrorSnackBar('Error',
            'Failed to fetch student names: ${failure.failure.toString()}');
        isLoadingStudentNames.value = false;
      },
      (names) {
        studentNames.value = names;
        isLoadingStudentNames.value = false;
      },
    );
  }

  Future<void> fetchQueries(TeacherCourse course) async {
    isLoadingQueries.value = true;

    final result = await getQueriesUseCase.execute(course);
    result.fold(
      (failure) {
        Utils().showErrorSnackBar(
            'Error', 'Failed to fetch queries: ${failure.failure.toString()}');
        isLoadingQueries.value = false;
      },
      (queries) {
        allQueries.value = queries;
        _filterQueries();
        isLoadingQueries.value = false;
      },
    );
  }

  Future<void> respondToQuery(String queryId, String response) async {
    final params = RespondToQueryParams(
        queryId: queryId, response: response, course: selectedCourse!);

    final result = await respondToQueryUseCase.execute(params);
    result.fold(
      (failure) {
        Utils().showErrorSnackBar('Error',
            'Failed to respond to query: ${failure.failure.toString()}');
      },
      (_) {
        Utils().showSuccessSnackBar('Success', 'Response sent successfully');
        // Refresh queries to update the list
        if (allQueries.isNotEmpty) {
          fetchQueries(
              selectedCourse!); // This will need to be updated with actual courseId
        }
      },
    );
  }

  void _filterQueries() {
    pendingQueries.value =
        allQueries.where((query) => query.status == 'pending').toList();
    respondedQueries.value =
        allQueries.where((query) => query.status == 'responded').toList();
  }
}
