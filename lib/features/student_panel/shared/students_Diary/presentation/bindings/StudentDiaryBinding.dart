import 'package:get/get.dart';
import '../../data/datasources/StudentRemoteDataSource.dart';
import '../../data/repositories/StudentDiaryRepositoryImpl.dart';
import '../../domain/usecases/GetNotesUseCases.dart';
import '../../domain/repositories/StudentDiaryRepository.dart';
import '../../domain/usecases/ToggleNoteCompletionUseCase.dart' show ToggleNoteCompletionUseCase;

class StudentDiaryBinding extends Bindings {
  @override
  void dependencies() {
    // Data Layer
    Get.lazyPut<NoteRemoteDataSource>(() => NoteRemoteDataSource());

    // Repository
    Get.lazyPut<StudentDiaryRepository>(() => NoteRepositoryImpl());

    // Use Cases
    Get.lazyPut(() => GetAllNotesUseCase(Get.find()));
    Get.lazyPut(() => AddNoteUseCase(Get.find()));
    Get.lazyPut(() => UpdateNoteUseCase(Get.find()));
    Get.lazyPut(() => DeleteNoteUseCase(Get.find()));
    Get.lazyPut(() => ToggleNoteCompletionUseCase(Get.find()));

    // Controller
    Get.lazyPut(() => StudentDiaryController(
      getAllNotesUseCase: Get.find(),
      addNoteUseCase: Get.find(),
      updateNoteUseCase: Get.find(),
      deleteNoteUseCase: Get.find(),
      toggleNoteCompletionUseCase: Get.find(),
    ));
  }
}
