import 'package:auto_size_text/auto_size_text.dart';
import 'package:digital_academic_portal/features/admin/shared/student/presentation/pages/StudentDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../domain/entities/Student.dart';
import '../controllers/StudentController.dart';

class SemesterStudentsPage extends StatefulWidget {
  final String deptName;
  final String semester;

  const SemesterStudentsPage({super.key, required this.deptName, required this.semester});

  @override
  State<SemesterStudentsPage> createState() => _SemesterStudentsPageState();
}

class _SemesterStudentsPageState extends State<SemesterStudentsPage> {
  final StudentController controller = Get.find();
  final addStudentKey = GlobalKey<FormState>();
  final editStudentKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller.showSemesterStudents(widget.deptName, widget.semester);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150.0,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(bottom: 70),
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Students',
                      style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'Ubuntu', fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),

                    AutoSizeText('${widget.deptName.trim()} Semester - ${widget.semester.split('-').last}', maxLines: 1, maxFontSize: 12,
                        style: TextStyle(color: Colors.white, fontFamily: 'Ubuntu', fontWeight: FontWeight.bold)
                    ),
                    SizedBox(height: 2),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      const Color(0xFF1B7660)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 55,
                      child: TextField(
                        onChanged: (query) {
                          controller.filterStudents(query);
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(2),
                          hintText: 'Search Students...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Obx(() {
            if (controller.isLoading.value) {
              return SliverFillRemaining(
                child: Center(
                  child: Lottie.asset(
                    'assets/animations/loading_animation4.json',
                    width: 120,
                    height: 120,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              );
            } else {
              if ( controller.filteredStudentList.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text("No Students available")),
                );
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      final student =  controller.filteredStudentList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                student.studentName[0], // Show initial of student's name
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              student.studentRollNo,
                              style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                            ),
                            subtitle: Text(
                              'Name: ${student.studentName}\nFather: ${student.fatherName}',
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Get.to(StudentDetailPage(student: student));
                            },
                          ),
                        ),
                      );
                    },
                    childCount:  controller.filteredStudentList.length,
                  ),
                );
              }
            }
          }),
        ],
      ),
    );
  }

}
