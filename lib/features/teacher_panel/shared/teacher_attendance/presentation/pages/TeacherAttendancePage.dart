import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Student {
  final String name;
  bool isPresent;

  Student({required this.name, this.isPresent = true});
}

class TeacherAttendancePage extends StatefulWidget {
  final String teacherDept;

  const TeacherAttendancePage({super.key, required this.teacherDept});

  @override
  State<TeacherAttendancePage> createState() => _TeacherAttendancePageState();
}

class _TeacherAttendancePageState extends State<TeacherAttendancePage> {
  final RxString selectedCourse = ''.obs;
  final List<String> dummyCourses = [
    'BSCS-6A - OOP',
    'BSIT-4B - DBMS',
    'BSSE-8A - AI',
  ];

  final RxList<Student> studentList = List.generate(
    25,
        (index) => Student(name: 'Student ${index + 1} (Ahmed, Fatima, Ali...)'),
  ).obs;

  void submitAttendance() {
    int presentCount = studentList.where((s) => s.isPresent).length;
    int absentCount = studentList.length - presentCount;

    Get.snackbar(
      'Attendance Submitted',
      '$presentCount Present, $absentCount Absent',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mark Attendance"),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown
            Obx(() => DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Course",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              value: selectedCourse.value.isNotEmpty
                  ? selectedCourse.value
                  : null,
              items: dummyCourses
                  .map((course) => DropdownMenuItem<String>(
                value: course,
                child: Text(course),
              ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedCourse.value = value;
                }
              },
            )),

            const SizedBox(height: 20),

            Expanded(
              child: Obx(() => ListView.separated(
                itemCount: studentList.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final student = studentList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(student.name[0]),
                      backgroundColor:
                      student.isPresent ? Colors.green : Colors.red,
                    ),
                    title: Text(student.name),
                    trailing: Switch(
                      value: student.isPresent,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      onChanged: (value) {
                        studentList[index].isPresent = value;
                        studentList.refresh(); // Triggers UI update
                      },
                    ),
                  );
                },
              )),
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: submitAttendance,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text(
                "Submit Attendance",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
