import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/StudentController.dart';
import 'StudentDetailPage.dart';

class AllStudentsPage extends StatefulWidget {
  const AllStudentsPage({super.key});

  @override
  State<AllStudentsPage> createState() => _AllStudentsPageState();
}

class _AllStudentsPageState extends State<AllStudentsPage> {
  final StudentController controller = Get.find();

  @override
  void initState() {
    controller.showAllStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          Obx(() {
            return SliverAppBar(
              expandedHeight: 150.0,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(
                    bottom: controller.titlePadding.value),
                centerTitle: true,
                title: const SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Keeps the column compact
                    children: [
                      Text(
                        'Students',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'All Departments',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme
                            .of(context)
                            .primaryColor,
                        const Color(0xFF1B7660),
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
            );
          }),

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
              if (controller.filteredStudentList.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text("No Students available")),
                );
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      final student = controller.filteredStudentList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0,
                            vertical: 5.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme
                                  .of(context)
                                  .primaryColor,
                              child: Text(
                                student.studentName[0],
                                // Show initial of student's name
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              student.studentRollNo,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: Theme
                                  .of(context)
                                  .primaryColor),
                            ),
                            subtitle: Text(
                              'Name: ${student.studentName}\nFather: ${student
                                  .fatherName}',
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Get.to(StudentDetailPage(student: student));
                            },
                          ),
                        ),
                      );
                    },
                    childCount: controller.filteredStudentList.length,
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
