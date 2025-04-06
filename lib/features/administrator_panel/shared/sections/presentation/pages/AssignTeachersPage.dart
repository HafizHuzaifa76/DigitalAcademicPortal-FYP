import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/SectionController.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/sections/domain/entities/Section.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/teachers/domain/entities/Teacher.dart';

class AssignTeachersPage extends StatefulWidget {
  final String deptName;
  final String semester;
  final Section section;

  const AssignTeachersPage({
    super.key,
    required this.deptName,
    required this.semester,
    required this.section,
  });

  @override
  _AssignTeachersPageState createState() => _AssignTeachersPageState();
}

class _AssignTeachersPageState extends State<AssignTeachersPage> {
  final SectionController controller = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.selectedTeachers.value = {};
    Future.delayed(Duration.zero, () {
      controller.init(widget.deptName, widget.semester, widget.section.sectionName);
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var dept = widget.deptName;
    var semester = widget.semester;
    var section = widget.section;

    return Scaffold(
      body: Center(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            children: [
              Container(
                height: screenSize.height * .25,
                width: screenSize.width,
                padding: EdgeInsets.only(
                    top: 35,
                    left: screenSize.width * 0.035,
                    right: screenSize.width * 0.035,
                    bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 20,
                            child: SizedBox(
                              width: screenSize.width * 0.93,
                              child: Text(
                                '$dept\n$semester\nSection ${section.sectionName.replaceFirst(section.shift, '')}',
                                style: Theme.of(context).appBarTheme.titleTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            child: SizedBox(
                              width: screenSize.width * 0.93,
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: screenSize.width * 0.8,
                                    child: const Divider(height: 3),
                                  ),
                                  const Text(
                                    'Assign Teachers',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                padding: const EdgeInsets.all(8),
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: screenSize.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Center(
                        child: Lottie.asset(
                          'assets/animations/loading_animation4.json',
                          width: 120,
                          height: 120,
                          fit: BoxFit.scaleDown,
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ...controller.coursesList.map((course) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: FormField<Teacher>(
                                          validator: (value) {
                                            if (controller.selectedTeachers[course.courseName] == null) {
                                              return 'Please select a teacher';
                                            }
                                            return null;
                                          },
                                          builder: (FormFieldState<Teacher> state) {
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    course.courseName,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),

                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: state.hasError ? Colors.red: Colors.grey,
                                                      width: 1,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: DropdownButton<dynamic>(
                                                    hint: const Text("Select Teacher"),
                                                    value: controller.selectedTeachers[course.courseName],
                                                    underline: null,

                                                    items: controller.teacherList.map((teacher) {
                                                      return DropdownMenuItem<Teacher>(
                                                        value: teacher,
                                                        child: Text(teacher.teacherName),
                                                      );
                                                    }).toList(),
                                                    onChanged: (selectedTeacher) {
                                                      if(selectedTeacher == controller.selectedTeachers[course.courseName]) return ;

                                                      if (controller.isEdit.value == false) {
                                                        controller.changeCourseTeacher(course.courseName, selectedTeacher!);
                                                        state.didChange(selectedTeacher);
                                                      }
                                                      else {
                                                        showConfirmationBottomSheet(context, dept, semester, section.sectionName, course.courseName, selectedTeacher!);
                                                        state.didChange(selectedTeacher);
                                                      }
                                                      _formKey.currentState!.validate();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ))
                                    ]
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              if (controller.isEdit.value == false)
                                ElevatedButton(
                                onPressed: () {
                                  print(controller.selectedTeachers);
                                  if (_formKey.currentState!.validate()) {
                                    controller.assignTeacherToCourse(
                                      dept, semester, section.sectionName,
                                    );
                                  } else {
                                    Utils().showErrorSnackBar(
                                      'Validation Error',
                                      'Please select a teacher for all courses'
                                    );
                                  }
                                },
                                child: Text(
                                  controller.isEdit.value ? 'Update' : 'Assign',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showConfirmationBottomSheet(BuildContext context, String deptName, String semester, String section, String courseName, Teacher teacher) {
    Get.defaultDialog(
      title: 'Are you sure you want to change?',
      content: const SizedBox(),
      cancel: TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(100, 0)
        ),
        onPressed: () {
          controller.editAssignedTeacher(deptName, semester, section, courseName, teacher);
          Get.back();

        },
        child: const Text('Change', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

}
