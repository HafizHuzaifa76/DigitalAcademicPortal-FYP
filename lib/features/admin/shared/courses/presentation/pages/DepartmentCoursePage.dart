import 'package:digital_academic_portal/features/admin/shared/departments/domain/entities/Semester.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../domain/entities/Course.dart';
import '../controllers/CourseController.dart';
import 'CourseDetailPage.dart';


class DepartmentCoursePage extends StatefulWidget {
  final String deptName;
  final List<Semester> semestersList;
  const DepartmentCoursePage({super.key, required this.deptName, required this.semestersList});

  @override
  State<DepartmentCoursePage> createState() => _DepartmentCoursePageState();
}

class _DepartmentCoursePageState extends State<DepartmentCoursePage> {
  final CourseController controller = Get.find();

  @override
  void initState() {
    controller.showDeptCourses(widget.deptName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: ()=> addCourseDialog(),
          )
        ],
      ),
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {

            return Lottie.asset(
              'assets/animations/loading_animation4.json',
              width: 100,
              height: 100,
              fit: BoxFit.scaleDown,
            );
          }
          else {
            if (controller.courseList.isEmpty) {
              return const Center(child: Text("No Courses available"));
            } else {
              return ListView.builder(
                itemCount: controller.courseList.length,
                itemBuilder: (context, index) {
                  final course = controller.courseList[index];
                  return ListTile(
                    title: Text(course.courseName),
                    subtitle: const Text(''),
                    onTap: () {
                      Get.to(()=> CourseDetailPage(deptName: widget.deptName, course: course));
                    },
                  );
                },
              );
            }
          }
        }),
      ),
    );
  }

  Future addCourseDialog() async{
    final List<double> creditHoursOptions = [1.0, 2.0, 3.0];
    double selectedCreditHours = creditHoursOptions.last;
    var semesters = widget.semestersList;
    String selectedSemester = semesters[0].semesterName;
    return Get.defaultDialog(
      title: 'Add Course',

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller.courseCodeController,
            decoration: const InputDecoration(labelText: 'Course Code'),
          ),
          TextField(
            controller: controller.courseNameController,
            decoration: const InputDecoration(labelText: 'Course Name'),
          ),
          DropdownButtonFormField<String>(
            value: selectedSemester,
            decoration: const InputDecoration(labelText: 'Semester'),
            items: semesters.map((semester) {
              return DropdownMenuItem(
                value: semester.semesterName,
                child: Text(semester.semesterName),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedSemester = value!;
              });
            },
          ),
          DropdownButtonFormField<double>(
            value: selectedCreditHours,
            decoration: const InputDecoration(labelText: 'Credit Hours'),
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
        ],
      ),
      onCancel: ()=> Get.back(),
      textConfirm: 'Add',
      onConfirm: (){
        var newCourse = Course(
          courseCode: controller.courseCodeController.text,
          courseName: controller.courseNameController.text,
          courseDept: widget.deptName,
          courseCreditHours: selectedCreditHours,
          courseSemester: selectedSemester,
        );

        controller.addCourse(newCourse);
        Get.back();
      }
    );
  }

  Future editCourseDialog(Course course) async {
    // Initialize fields with the values from the existing course
    final List<double> creditHoursOptions = [1.0, 2.0, 3.0];
    double selectedCreditHours = course.courseCreditHours;

    // Create controllers and set their initial values
    controller.courseCodeController = TextEditingController(text: course.courseCode);
    controller.courseNameController = TextEditingController(text: course.courseName);

    return Get.defaultDialog(
      title: 'Edit Course',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller.courseCodeController,
            decoration: const InputDecoration(labelText: 'Course Code'),
          ),
          TextField(
            controller: controller.courseNameController,
            decoration: const InputDecoration(labelText: 'Course Name'),
          ),
          DropdownButtonFormField<double>(
            value: selectedCreditHours,
            decoration: const InputDecoration(labelText: 'Credit Hours'),
            items: creditHoursOptions.map((hours) {
              return DropdownMenuItem(
                value: hours,
                child: Text('$hours Credit Hours'),
              );
            }).toList(),
            onChanged: (value) {
              selectedCreditHours = value!;
            },
          ),
        ],
      ),
      onCancel: () => Get.back(),
      textConfirm: 'Save',
      onConfirm: () {
        var updatedCourse = Course(
          courseCode: controller.courseCodeController.text,
          courseName: controller.courseNameController.text,
          courseDept: course.courseDept,
          courseCreditHours: selectedCreditHours,
          courseSemester: course.courseSemester,
        );

        controller.editCourse(updatedCourse);
        Get.back();
      },
    );
  }

}
