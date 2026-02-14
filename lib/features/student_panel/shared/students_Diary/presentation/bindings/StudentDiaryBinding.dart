import 'package:digital_academic_portal/features/student_panel/shared/students_Diary/data/datasources/StudentDiaryRemoteDatasource.dart';
import 'package:digital_academic_portal/features/student_panel/shared/students_Diary/domain/repositories/StudentDiaryRepository.dart';
import 'package:get/get.dart';

import '../../data/repositories/StudentDiaryRepositoryImpl.dart';
import '../../domain/usecases/AddNoteUseCase.dart';
import '../../domain/usecases/AllNotesUseCase.dart';
import '../../domain/usecases/DeleteNoteUseCase.dart';
import '../../domain/usecases/EditNoteUseCase.dart';
import '../controller/StudentDiaryController.dart';

class StudentDiaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentDiaryRemoteDatasource>(
      () => StudentDiaryRemoteDatasourceImpl(),
    );

    Get.lazyPut<StudentDiaryRepository>(
      () => StudentDiaryRepositoryImpl(Get.find()),
    );

    Get.lazyPut(() => AddNoteUseCase(Get.find()));
    Get.lazyPut(() => EditNoteUseCase(Get.find()));
    Get.lazyPut(() => DeleteNoteUseCase(Get.find()));
    Get.lazyPut(() => AllNotesUseCase(Get.find()));

    Get.lazyPut(() => StudentDiaryController(
          addNoteUseCase: Get.find(),
          editNoteUseCase: Get.find(),
          deleteNoteUseCase: Get.find(),
          allNotesUseCase: Get.find(),
        ));
  }
}
