
import 'package:digital_academic_portal/features/admin/shared/courses/data/datasources/CourseRemoteDataSource.dart';
import 'package:digital_academic_portal/features/admin/shared/courses/data/repositories/CourseRepositoryImpl.dart';
import 'package:digital_academic_portal/features/admin/shared/courses/domain/repositories/CourseRepository.dart';
import 'package:digital_academic_portal/features/admin/shared/sections/domain/usecases/AssignTeachersUseCase.dart';
import 'package:digital_academic_portal/features/admin/shared/teachers/data/datasources/TeacherRemoteDataSource.dart';
import 'package:digital_academic_portal/features/admin/shared/teachers/data/repositories/TeacherRepositoryImpl.dart';
import 'package:digital_academic_portal/features/admin/shared/teachers/domain/repositories/TeacherRepository.dart';
import 'package:get/get.dart';

import '../../../courses/domain/usecases/SemesterCoursesUseCase.dart';
import '../../../teachers/domain/usecases/DeptTeacherUseCase.dart';
import '../../data/datasources/SectionRemoteDataSource.dart';
import '../../data/repositories/SectionRepositoryImpl.dart';
import '../../domain/repositories/SectionRepository.dart';
import '../../domain/usecases/AddSectionUseCase.dart';
import '../../domain/usecases/AllSectionsUseCase.dart';
import '../../domain/usecases/DeleteSectionUseCase.dart';
import '../../domain/usecases/EditSectionUseCase.dart';
import '../../domain/usecases/GetCoursesUseCase.dart';
import '../../domain/usecases/GetTeachersUseCase.dart';
import '../controllers/SectionController.dart';

class SectionBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<SectionRemoteDataSource>(() => SectionRemoteDataSourceImpl());
    Get.lazyPut<CourseRemoteDataSource>(() => CourseRemoteDataSourceImpl());
    Get.lazyPut<TeacherRemoteDataSource>(() => TeacherRemoteDataSourceImpl());
    Get.lazyPut<SectionRepository>(() => SectionRepositoryImpl(sectionRemoteDataSource: Get.find()));
    Get.lazyPut<CourseRepository>(() => CourseRepositoryImpl(courseRemoteDataSource: Get.find()));
    Get.lazyPut<TeacherRepository>(() => TeacherRepositoryImpl(teacherRemoteDataSource: Get.find()));
    Get.lazyPut(() => AllSectionsUseCase(Get.find()));
    Get.lazyPut(() => AddSectionUseCase(Get.find()));
    Get.lazyPut(() => EditSectionUseCase(Get.find()));
    Get.lazyPut(() => DeleteSectionUseCase(Get.find()));
    Get.lazyPut(() => GetCoursesUseCase(Get.find()));
    Get.lazyPut(() => SemesterCoursesUseCase(Get.find()));
    Get.lazyPut(() => AssignTeachersUseCase(Get.find()));
    Get.lazyPut(() => FetchAssignedTeachersUseCase(Get.find()));
    Get.lazyPut(() => EditAssignTeachersUseCase(Get.find()));
    Get.lazyPut(() => GetTeachersUseCase(Get.find()));
    Get.lazyPut(() => DeptTeachersUseCase(Get.find()));
    Get.lazyPut(() => SectionController(addSectionUseCase: Get.find(), deleteSectionUseCase: Get.find(), getCoursesUseCase: Get.find(), getTeachersUseCase: Get.find(), editSectionUseCase: Get.find(), allSectionsUseCase: Get.find(), assignTeachersUseCase: Get.find(), fetchAssignedTeachersUseCase: Get.find(), editAssignTeachersUseCase: Get.find()));
  }

}