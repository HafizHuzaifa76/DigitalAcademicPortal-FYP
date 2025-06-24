import 'package:digital_academic_portal/features/teacher_panel/shared/teacher_grades/domain/repositories/TeacherGradeRepository.dart';
import 'package:get/get.dart';
import '../controllers/TeacherGradeController.dart';
import '../../domain/usecases/GetMarkingGradesUseCase.dart';
import '../../domain/usecases/SaveMarkingGradesUseCase.dart';
import '../../domain/usecases/GetCourseGradesUseCase.dart';
import '../../domain/usecases/CreateCourseGradeUseCase.dart';
import '../../domain/usecases/GetTeacherCoursesUseCase.dart';
import '../../data/repositories/TeacherGradeRepositoryImpl.dart';
import '../../data/datasources/TeacherGradeRemoteDataSource.dart';
import '../../../teacher_courses/data/datasources/TeacherCourseRemoteDataSource.dart';
import '../../../teacher_courses/data/repositories/TeacherCourseRepositoryImpl.dart';
import '../../../teacher_courses/domain/repositories/TeacherCourseRepository.dart';
import '../../../teacher_courses/domain/usecases/FetchAllTeacherCoursesUseCase.dart';
import '../../domain/usecases/DeleteGradeUseCase.dart';
import '../../domain/usecases/UpdateGradeUseCase.dart';
import '../../domain/usecases/SubmitCourseGradesUseCase.dart';

class TeacherGradeBinding extends Bindings {
  @override
  void dependencies() {
    // Course dependencies
    Get.lazyPut<TeacherCourseRemoteDataSource>(
      () => TeacherCourseRemoteDataSourceImpl(),
    );

    Get.lazyPut<TeacherCourseRepository>(
      () => TeacherCourseRepositoryImpl(Get.find()),
    );

    Get.lazyPut(() => FetchAllTeacherCoursesUseCase(Get.find()));

    // Grade dependencies
    Get.lazyPut<TeacherGradeRemoteDataSource>(
      () => TeacherGradeRemoteDataSourceImpl(),
    );

    Get.lazyPut<TeacherGradeRepository>(
      () => TeacherGradeRepositoryImpl(
        Get.find<TeacherGradeRemoteDataSource>(),
      ),
    );

    // Use Cases
    Get.lazyPut<GetTeacherCoursesUseCase>(
      () => GetTeacherCoursesUseCase(Get.find()),
    );

    Get.lazyPut<GetMarkingGradesUseCase>(
      () => GetMarkingGradesUseCase(Get.find()),
    );

    Get.lazyPut<SaveMarkingGradesUseCase>(
      () => SaveMarkingGradesUseCase(Get.find()),
    );

    Get.lazyPut<GetCourseGradesUseCase>(
      () => GetCourseGradesUseCase(Get.find()),
    );

    Get.lazyPut<CreateCourseGradeUseCase>(
      () => CreateCourseGradeUseCase(Get.find()),
    );

    Get.lazyPut<DeleteGradeUseCase>(
      () => DeleteGradeUseCase(Get.find()),
    );

    Get.lazyPut<UpdateGradeUseCase>(
      () => UpdateGradeUseCase(Get.find()),
    );

    Get.lazyPut<SubmitCourseGradesUseCase>(
      () => SubmitCourseGradesUseCase(Get.find()),
    );

    // Controllers
    Get.lazyPut<TeacherGradeController>(
      () => TeacherGradeController(
        getMarkingGradesUseCase: Get.find<GetMarkingGradesUseCase>(),
        saveMarkingGradesUseCase: Get.find<SaveMarkingGradesUseCase>(),
        getCourseGradesUseCase: Get.find<GetCourseGradesUseCase>(),
        createCourseGradeUseCase: Get.find<CreateCourseGradeUseCase>(),
        deleteGradeUseCase: Get.find<DeleteGradeUseCase>(),
        updateGradeUseCase: Get.find<UpdateGradeUseCase>(),
        getTeacherCoursesUseCase: Get.find<GetTeacherCoursesUseCase>(),
        submitCourseGradesUseCase: Get.find<SubmitCourseGradesUseCase>(),
      ),
    );
  }
}
