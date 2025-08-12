import 'package:get/get.dart';
import '../../../../../../shared/domain/entities/TimeTable.dart';
import '../../domain/usecases/FetchStudentTimetable.dart';

class StudentTimetableController extends GetxController {
  final FetchStudentTimetable fetchStudentTimetable;
  final RxBool isLoading = false.obs;
  final RxList<TimeTableEntry> timeTableEntries = <TimeTableEntry>[].obs;

  StudentTimetableController(this.fetchStudentTimetable);

  Future<void> loadStudentTimetable() async {
    isLoading.value = true;
    final result = await fetchStudentTimetable.execute(null);

    result.fold(
      (failure) {
        // Handle error
        Get.snackbar('Error', failure.toString());
      },
      (timetable) {
        print(timetable);
        timeTableEntries.assignAll(timetable);
      },
    );
    isLoading.value = false;
  }
}
