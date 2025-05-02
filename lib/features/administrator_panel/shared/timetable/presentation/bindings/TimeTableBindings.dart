
import 'package:digital_academic_portal/features/administrator_panel/shared/sections/domain/usecases/AssignTeachersUseCase.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/timetable/domain/usecases/FetchAssignedTeachersUseCase.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/timetable/domain/usecases/FetchSectionTimeTable.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/timetable/domain/usecases/GetCoursesUseCase.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/timetable/domain/usecases/GetSectionsUseCase.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/timetable/domain/usecases/GetTeachersUseCase.dart';
import 'package:get/get.dart';

import '../../../courses/data/datasources/CourseRemoteDataSource.dart';
import '../../../courses/data/repositories/CourseRepositoryImpl.dart';
import '../../../courses/domain/repositories/CourseRepository.dart';
import '../../../courses/domain/usecases/SemesterCoursesUseCase.dart';
import '../../../sections/data/datasources/SectionRemoteDataSource.dart';
import '../../../sections/data/repositories/SectionRepositoryImpl.dart';
import '../../../sections/domain/repositories/SectionRepository.dart';
import '../../../sections/domain/usecases/AllSectionsUseCase.dart';
import '../../../teachers/data/datasources/TeacherRemoteDataSource.dart';
import '../../../teachers/data/repositories/TeacherRepositoryImpl.dart';
import '../../../teachers/domain/repositories/TeacherRepository.dart';
import '../../../teachers/domain/usecases/DeptTeacherUseCase.dart';
import '../../data/datasources/TimeTableRemoteDataSource.dart';
import '../../data/repositories/TimeTableRepositoryImpl.dart';
import '../../domain/repositories/TimeTableRepository.dart';
import '../../domain/usecases/AddTimetableEntryUseCase.dart';
import '../../domain/usecases/AllTimetableEntryUseCase.dart';
import '../../domain/usecases/DeleteTimetableEntryUseCase.dart';
import '../../domain/usecases/EditTimetableEntryUseCase.dart';
import '../controllers/TimeTableController.dart';

class TimeTableBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut<SectionRemoteDataSource>(() => SectionRemoteDataSourceImpl());
    Get.lazyPut<CourseRemoteDataSource>(() => CourseRemoteDataSourceImpl());
    Get.lazyPut<TeacherRemoteDataSource>(() => TeacherRemoteDataSourceImpl());
    Get.lazyPut<SectionRepository>(() => SectionRepositoryImpl(sectionRemoteDataSource: Get.find()));
    Get.lazyPut<CourseRepository>(() => CourseRepositoryImpl(courseRemoteDataSource: Get.find()));
    Get.lazyPut<TeacherRepository>(() => TeacherRepositoryImpl(teacherRemoteDataSource: Get.find()));
    Get.lazyPut<TimeTableRemoteDataSource>(() => TimeTableRemoteDataSourceImpl());
    Get.lazyPut<TimeTableRepository>(() => TimeTableRepositoryImpl(timeTableRemoteDataSource: Get.find()));
    Get.lazyPut(() => AllTimeTablesUseCase(Get.find()));
    Get.lazyPut(() => FetchSectionTimeTable(Get.find()));
    Get.lazyPut(() => AddTimeTableUseCase(Get.find()));
    Get.lazyPut(() => EditTimeTableUseCase(Get.find()));
    Get.lazyPut(() => DeleteTimeTableUseCase(Get.find()));
    Get.lazyPut(() => GetAssignedTeachersUseCase(Get.find()));
    Get.lazyPut(() => GetTimeTableCoursesUseCase(Get.find()));
    Get.lazyPut(() => GetTimeTableTeachersUseCase(Get.find()));
    Get.lazyPut(() => GetSectionsUseCase(Get.find()));
    Get.lazyPut(() => AllSectionsUseCase(Get.find()));
    Get.lazyPut(() => SemesterCoursesUseCase(Get.find()));
    Get.lazyPut(() => DeptTeachersUseCase(Get.find()));
    Get.lazyPut(() => FetchAssignedTeachersUseCase(Get.find()));
    Get.lazyPut(() => TimeTableController(addTimeTableUseCase: Get.find(), deleteTimeTableUseCase: Get.find(), editTimeTableUseCase: Get.find(), allTimeTablesUseCase: Get.find(), fetchAssignedTeachersUseCase: Get.find(), getCoursesUseCase: Get.find(), getTeachersUseCase: Get.find(), getSectionsUseCase: Get.find(), fetchSectionTimeTable: Get.find()));
  }

}