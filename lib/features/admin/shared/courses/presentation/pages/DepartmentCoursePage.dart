

import 'package:digital_academic_portal/features/admin/shared/courses/domain/entities/DepartmentCourse.dart';
import 'package:digital_academic_portal/features/admin/shared/courses/presentation/pages/SemesterWiseCourseScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../departments/domain/entities/Semester.dart';
import '../controllers/CourseController.dart';
import 'AllCoursesScreen.dart';

class DepartmentCoursePage extends StatefulWidget {
  final String deptName;
  final String deptCode;
  final List<Semester> semestersList;

  const DepartmentCoursePage({super.key, required this.deptName, required this.deptCode, required this.semestersList});

  @override
  _DepartmentCoursePageState createState() => _DepartmentCoursePageState();
}

class _DepartmentCoursePageState extends State<DepartmentCoursePage> {
  final CourseController controller = Get.find();

  @override
  void initState() {
    controller.semesterList = widget.semestersList;
    controller.showDeptCourses(widget.deptName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      SemesterWiseCourseScreen(deptName: widget.deptName, deptCode: widget.deptCode),

      AllCoursesScreen(deptName: widget.deptName),
    ];

    return Scaffold(
      body: screens[controller.selectedTab.value], // Display selected screen

      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
        backgroundColor: Theme.of(context).primaryColor,
        direction: SpeedDialDirection.values.first,
        children: [
          SpeedDialChild(
            child: const Icon(FontAwesomeIcons.fileExcel, color: Colors.white),
            backgroundColor: Colors.blue,
            label: 'Add Courses List',
            onTap: () => showExcelBottomSheet(context),
          ),
          SpeedDialChild(
            child: const Icon(CupertinoIcons.plus, color: Colors.white),
            backgroundColor: Colors.green,
            label: 'Add course manually',
            onTap: () => addCourseBottomSheet(context, ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MaterialButton(
              onPressed: () {
                controller.onTabChanged(0);
              },
              minWidth: 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 32,
                    color: controller.selectedTab.value == 0 ? Get.theme.primaryColor : Colors.grey.shade600,
                  ),
                  Text('Semester-wise', style: TextStyle(color: controller.selectedTab.value == 0 ? Get.theme.primaryColor : Colors.grey.shade600),)
                ],
              ),
            ),
            const SizedBox(width: 1),
            MaterialButton(
              onPressed: () {
                controller.onTabChanged(1);
              },
              minWidth: 40,
              child: Column(
                children: [
                  Icon(
                    Icons.book_outlined,
                    size: 35,
                    color: controller.selectedTab.value == 1 ? Get.theme.primaryColor : Colors.grey.shade600,
                  ),
                  Text('All', style: TextStyle(color: controller.selectedTab.value == 1 ? Get.theme.primaryColor : Colors.grey.shade600),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future addCourseBottomSheet(BuildContext context) async {
    final List<int> creditHoursOptions = [1, 2, 3];
    int selectedCreditHours = creditHoursOptions.last;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Add Course',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme
                          .of(context)
                          .primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: controller.courseCodeController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            ),
                            labelText: 'Course Code',
                          ),
                        ),
                        const SizedBox(height: 10),

                        TextField(
                          controller: controller.courseNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            ),
                            labelText: 'Course Name',
                          ),
                        ),
                        const SizedBox(height: 10),

                        DropdownButtonFormField<int>(
                          value: selectedCreditHours,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            ),
                            labelText: 'Credit Hours',
                          ),
                          items: creditHoursOptions.map((hours) {
                            return DropdownMenuItem(
                              value: hours,
                              child: Text('$hours Credit Hours'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCreditHours = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: const ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, 45))),
                  onPressed: () {
                      var newCourse = DepartmentCourse(
                        courseCode: '${widget.deptCode}-${controller.courseCodeController.text}',
                        courseName: controller.courseNameController.text,
                        courseDept: widget.deptName,
                        courseCreditHours: selectedCreditHours,
                      );

                      controller.addCourse(newCourse);
                      Get.back();
                  },
                  child: const Text('Add', style: TextStyle(fontFamily: 'Ubuntu', fontSize: 20, color: Colors.white)),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Future showExcelBottomSheet(BuildContext context) {
    List<String> columns = ['Course Title', 'Course Code', 'Credit Hours'];
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Add Courses', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, fontFamily: 'Ubuntu'),),
              const SizedBox(height: 10),

              const Text(
                'Your Excel sheet should contain these columns:',
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
              ),
              const SizedBox(height: 10),
              // List the columns
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20.0,
                runSpacing: 10.0,
                children: columns.map((col) => SizedBox(
                  width: (MediaQueryData.fromView(WidgetsBinding.instance.window).size.width / 3) - 30,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(3)
                    ),
                    child: Text(
                      col,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Ubuntu'),
                    ),
                  ),
                ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Important',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18, fontFamily: 'Ubuntu'),
              ),
              const Text(
                'Course Code should be unique',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontFamily: 'Ubuntu'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller.fetchCoursesFromExcel(widget.deptName).then((coursesList){
                    controller.addCourseList(coursesList);
                  });
                },
                child: const Text('Select File', style: TextStyle(color: Colors.white, fontFamily: 'Ubuntu', fontSize: 18)),
              ),
            ],
          ),
        );
      },
    );
  }

}