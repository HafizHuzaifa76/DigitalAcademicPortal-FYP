import 'package:get/get.dart';
import '../../../../../../shared/domain/entities/TimeTable.dart';
import '../../domain/usecases/FetchTeacherTimetable.dart';

class TeacherTimeTableController extends GetxController {
  final FetchTeacherTimetable fetchTeacherTimetable;
  final RxBool isLoading = false.obs;
  final RxList<TimeTableEntry> timeTableEntries = <TimeTableEntry>[].obs;

  TeacherTimeTableController(this.fetchTeacherTimetable);

  Future<void> loadTeacherTimetable(String teacherDept) async {
    isLoading.value = true;
    final result = await fetchTeacherTimetable.execute(teacherDept);

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
