import 'package:digital_academic_portal/features/administrator_panel/presentation/pages/AdministratorDashboardPage.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/calendar_events/presentation/bindings/CalendarEventBindings.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/calendar_events/presentation/pages/CalendarEventPage.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/courses/presentation/bindings/CourseBindings.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/courses/presentation/pages/AllCoursesPage.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/noticeboard/presentation/pages/NoticeBoardPage.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/sections/presentation/bindings/SectionBindings.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/student/presentation/bindings/StudentBindings.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/student/presentation/pages/DepartmentStudentsPage.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/student/presentation/pages/SemesterStudentsPage.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/teachers/presentation/bindings/TeacherBindings.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/teachers/presentation/pages/AllTeachersPage.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/teachers/presentation/pages/DeptTeacherPage.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/timetable/presentation/bindings/TimeTableBindings.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/timetable/presentation/pages/SectionTimeTablePage.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/timetable/presentation/pages/SemesterTimeTablePage.dart';
import 'package:digital_academic_portal/features/auth/presentation/pages/LoginPage.dart';
import 'package:digital_academic_portal/features/teacher_panel/presentation/bindings/TeacherBindings.dart';
import 'package:digital_academic_portal/features/teacher_panel/presentation/pages/TeacherDashboardPage.dart';
import 'package:digital_academic_portal/features/teacher_panel/shared/teacher_calendar_events/presentation/bindings/TeacherCalendarEventBinding.dart';
import 'package:digital_academic_portal/features/teacher_panel/shared/teacher_courses/presentation/bindings/TeacherCourseBinding.dart';
import 'package:digital_academic_portal/features/teacher_panel/shared/teacher_courses/presentation/pages/TeacherCoursesPage.dart';
import 'package:digital_academic_portal/shared/presentation/pages/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:digital_academic_portal/features/student_panel/shared/student_calendar_events/presentation/pages/Stu_CalendarEventPage.dart';
import 'features/administrator_panel/shared/courses/presentation/pages/DepartmentCoursePage.dart';
import 'features/administrator_panel/shared/courses/presentation/pages/SemesterCoursePage.dart';
import 'features/administrator_panel/shared/departments/presentation/bindings/DepartmentBindings.dart';
import 'features/administrator_panel/shared/departments/presentation/pages/DepartmentPage.dart';
import 'features/administrator_panel/shared/noticeboard/presentation/bindings/NoticeBoardBindings.dart';
import 'features/administrator_panel/shared/sections/presentation/pages/SectionListPage.dart';
import 'features/administrator_panel/shared/student/presentation/pages/AllStudentsPage.dart';
import 'features/auth/presentation/bindings/AuthBinding.dart';
import 'features/student_panel/presentation/pages/StudentPanelDashboardPage.dart';
import 'features/student_panel/shared/student_attendance/presentation/pages/Stu_Attendance.dart';
import 'features/student_panel/shared/student_chatbot/presentation/pages/Stu_ChatBot.dart';
import 'features/student_panel/shared/student_courses/presentation/pages/Stu_AllCourses.dart';
import 'features/student_panel/shared/student_grades/presentation/pages/Stu_GradesScreen.dart';
import 'features/student_panel/shared/student_noticeboard/presentation/pages/Stu_MainNoticeBoardPage.dart';
import 'features/student_panel/shared/student_report/presentation/pages/Stu_Reports.dart';
import 'features/student_panel/shared/student_timetable/presentation/pages/Stu_TimeTablePage.dart';
import 'features/student_panel/shared/students_Diary/presentation/pages/Stu_Diary.dart';
import 'features/teacher_panel/shared/teacher_attendance/presentation/pages/Tch_Attendance.dart';
import 'features/teacher_panel/shared/teacher_calendar_events/presentation/pages/Tch_CalendarEventPage.dart';
import 'features/teacher_panel/shared/teacher_courses/presentation/pages/Tch_AllCourses.dart';
import 'features/teacher_panel/shared/teacher_announcement/presentation/pages/TeacherAnnouncementPage.dart';
import 'features/teacher_panel/shared/teacher_queries/presentation/pages/TeacherQueryPage.dart';
import 'features/teacher_panel/shared/teacher_timetable/presentation/pages/Tch_TimeTablePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.cubeGrid
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 52.0
    ..radius = 10.0
    ..progressColor = Colors.blue
    ..backgroundColor = const Color(0xFF9FE2BF)
    ..indicatorColor = const Color(0xFF145849)
    ..textColor = const Color(0xFF145849)
    ..textStyle = const TextStyle(
        fontSize: 18,
        fontFamily: 'Ubuntu',
        fontWeight: FontWeight.bold,
        color: Color(0xFF145849))
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digital Academic Portal',
      theme: ThemeData(
          fontFamily: 'Ubuntu',
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF145849)),
          primaryColor: const Color(0xFF145849),
          primaryColorLight: const Color(0xFFF2E8AD),
          // primaryColorDark: const Color(0xFFE1AD01),
          primaryColorDark: const Color(0xFF9FE2BF),
          // primaryColorDark: const Color(0xFFc3dfb7),
          // primaryColorLight: const Color(0xFF581420),
          // primaryColorLight: const Color(0xFF881452),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF145849),
              iconTheme:
                  IconThemeData(color: Colors.white), // Set icon color to white
              centerTitle: true,
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold)),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
            fixedSize: const WidgetStatePropertyAll(Size(double.maxFinite, 45)),
            textStyle:
                const WidgetStatePropertyAll(TextStyle(color: Colors.white)),
            backgroundColor: const WidgetStatePropertyAll(Color(0xFF145849)),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
          )),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
            fixedSize: const WidgetStatePropertyAll(Size(double.maxFinite, 45)),
            side: WidgetStatePropertyAll(
                BorderSide(color: Theme.of(context).primaryColor, width: 2)),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
          ))),
      initialBinding: AuthBinding(),
      builder: EasyLoading.init(),
      getPages: [
        GetPage(
            name: '/login',
            page: () => const LoginPage(),
            binding: AuthBinding()),
        GetPage(
          name: '/admin',
          page: () => const AdministratorDashboardPage(),
          // binding: DepartmentBinding()
        ),
        GetPage(
          name: '/teacherDashboard',
          page: () => const TeacherDashboardPage(),
          binding: TeacherDashboardBinding(),
        ),
        GetPage(
          name: '/studentDashboard',
          page: () => const StudentPortalDashboardPage(),
          // binding: DepartmentBinding()
        ),
        GetPage(
            name: '/departments',
            page: () => const DepartmentPage(),
            binding: DepartmentBinding()),
        GetPage(
          name: '/departmentStudents',
          page: () => DepartmentStudentsPage(
            deptName: Get.arguments['deptName'],
            deptCode: Get.arguments['deptCode'],
            semesterList: Get.arguments['semesterList'],
          ),
          binding: StudentBinding(),
        ),
        GetPage(
            name: '/semesterStudents',
            page: () => SemesterStudentsPage(
                  deptName: Get.arguments['deptName'],
                  semester: Get.arguments['semester'],
                ),
            binding: StudentBinding()),
        GetPage(
          name: '/allStudents',
          page: () => const AllStudentsPage(),
          binding: StudentBinding(),
        ),
        GetPage(
            name: '/deptTeachers',
            page: () => DeptTeacherPage(deptName: Get.arguments['deptName']),
            binding: TeacherBinding()),
        GetPage(
            name: '/allTeachers',
            page: () => const AllTeachersPage(),
            binding: TeacherBinding()),
        GetPage(
          name: '/deptCourses',
          page: () => DepartmentCoursePage(
              deptName: Get.arguments['deptName'],
              deptCode: Get.arguments['deptCode'],
              semestersList: Get.arguments['semesterList']),
          binding: CourseBinding(),
        ),
        GetPage(
            name: '/semesterCourses',
            page: () => SemesterCoursePage(
                deptName: Get.arguments['deptName'],
                semester: Get.arguments['semester']),
            binding: CourseBinding()),
        GetPage(
          name: '/allCourses',
          page: () => const AllCoursesPage(),
          binding: CourseBinding(),
        ),
        GetPage(
          name: '/allSections',
          page: () => MainSectionsListPage(
              deptName: Get.arguments['deptName'],
              semester: Get.arguments['semester']),
          binding: SectionBinding(),
        ),
        GetPage(
          name: '/mainNoticeBoard',
          page: () => const MainNoticeBoardPage(),
          binding: NoticeBoardBinding(),
        ),
        GetPage(
          name: '/student_NoticeBoard',
          page: () => const Stu_MainNoticeBoardPage(),
          //binding: NoticeBoardBinding(),
        ),
        GetPage(
          name: '/calendarPage',
          page: () => const CalendarEventPage(),
          binding: CalendarEventBinding(),
        ),
        GetPage(
          name: '/semesterTimeTablePage',
          page: () => SemesterTimeTablePage(
              deptName: Get.arguments['deptName'],
              semester: Get.arguments['semester']),
          binding: TimeTableBinding(),
        ),
        GetPage(
          name: '/sectionTimeTablePage',
          page: () => SectionTimeTablePage(
            deptName: Get.arguments['deptName'],
            semester: Get.arguments['semester'],
            section: Get.arguments['section'],
          ),
          binding: TimeTableBinding(),
        ),
        GetPage(
          name: '/student_calendarPage',
          page: () => const Stu_CalendarScreen(),
          //binding: CalendarEventBinding(),
        ),
        GetPage(
          name: '/student_timetablePage',
          page: () => const Stu_TimeTablePage(),
          //binding: CalendarEventBinding(),
        ),
        GetPage(
          name: '/student_gradesScreen',
          page: () => const Stu_GradesScreen(),
          //binding: CalendarEventBinding(),
        ),
        GetPage(
          name: '/Stu_ChatBot',
          page: () => const Stu_ChatBot(),
          //binding: CalendarEventBinding(),
        ),
        GetPage(
          name: '/student_allCourses',
          page: () => const Stu_AllCourses(),
          //binding: CalendarEventBinding(),
        ),
        GetPage(
          name: '/student_attendance',
          page: () => const Stu_Attendance(),
          //binding: CalendarEventBinding(),
        ),
        GetPage(
          name: '/student_diary',
          page: () => Stu_Diary(),
          //binding: CalendarEventBinding(),
        ),
        GetPage(
          name: '/Stu_report',
          page: () => const Stu_Reports(),
          //binding: CalendarEventBinding(),
        ),
        GetPage(
          name: '/teacherCalendarPage',
          page: () => const TeacherCalendarPage(),
          binding: TeacherCalendarEventBinding(),
        ),
        GetPage(
          name: '/teacherTimetablePage',
          page: () => const Tch_TimeTablePage(),
          //binding: CalendarEventBinding(),
        ),
        GetPage(
          name: '/teacherAnnouncement',
          page: () => const TeacherAnnouncementPage(),
          //binding: CalendarEventBinding(),
        ),
        GetPage(
          name: '/teacherQueryPage',
          page: () => const TeacherQueryPage(),
          //binding: CalendarEventBinding(),
        ),
        GetPage(
          name: '/teacherCoursesPage',
          page: () =>
              TeacherCoursesPage(teacherDept: Get.arguments['teacherDept']),
          binding: TeacherCourseBinding(),
        ),
        GetPage(
          name: '/teacher_attendance',
          page: () => const Tch_Attendance(),
          //binding: CalendarEventBinding(),
        ),
      ],
      home: const SplashScreen(),
    );
  }
}

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;

      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );

      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );

      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );

      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
      apiKey: "AIzaSyBu3YCSGvdi_iH0eCpYIH3XL_sfE3yWdgY",
      appId: '1:849792758725:android:10b9b0b477898c6a8911ac',
      messagingSenderId: '849792758725',
      projectId: 'digital-academic-portal',
      storageBucket: 'digital-academic-portal.appspot.com');

  static const FirebaseOptions ios = FirebaseOptions(
      apiKey: "AIzaSyCQTEbgi-zFbwqcv922K1zmrMXTMFmNu6U",
      appId: '1:849792758725:ios:3f0b2a778608e17a8911ac',
      messagingSenderId: '849792758725',
      projectId: 'digital-academic-portal',
      storageBucket: 'digital-academic-portal.appspot.com');

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyBGxWAnEytzIE2JAN4wE0Nv2RZbchBTZpo",
      authDomain: "digital-academic-portal.firebaseapp.com",
      projectId: "digital-academic-portal",
      storageBucket: "digital-academic-portal.firebasestorage.app",
      messagingSenderId: "849792758725",
      appId: "1:849792758725:web:1239caff45159a088911ac",
      measurementId: "G-YX93SV1GFK");
}
