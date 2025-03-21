import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../shared/presentation/widgets/ImageView.dart';
import '../../../sections/domain/entities/Section.dart';
import '../../../teachers/domain/entities/Teacher.dart';
import '../../domain/entities/TimeTable.dart';
import '../controllers/TimeTableController.dart';

class TimeTablePage extends StatefulWidget {
  final String deptName;
  final String semester;

  const TimeTablePage({super.key, required this.deptName, required this.semester});

  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  final TimeTableController controller = Get.find();
  final addTimeTableKey = GlobalKey<FormState>();
  final editTimeTableKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller.init(widget.deptName, widget.semester);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Get.theme.primaryColor,
        onPressed: () => addTimeTableBottomSheet(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          Obx(() {
            return SliverAppBar(
              expandedHeight: 150.0,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding:
                    EdgeInsets.only(bottom: controller.titlePadding.value),
                centerTitle: true,
                title: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('TimeTable Board',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                  ],
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Get.theme.primaryColor,
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
                            controller.filterTimeTables(query);
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(2),
                            hintText: 'Search TimeTables...',
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
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/noticeboard_icon.png',
                    height: 40,
                    width: 40,
                  ),
                ),
              ],
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
              if (controller.sectionList.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text("No TimeTables available")),
                );
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    var section = controller.sectionList[index];
                    controller.fetchAssignedTeacher(widget.deptName, widget.semester, section.sectionName);

                    List<Widget> courseWidgets = controller.coursesList.map((course) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              course.courseName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(controller.selectedTeachers[course.courseName] ?? 'Not selected'),
                            ),
                          ],
                        )
                    )).toList();
                    // final timeTable = controller.filteredTimeTableList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                section.sectionName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                  fontFamily: 'Ubuntu',
                                ),
                              ),

                              // Text(
                              //   'Remaining: ${semester.totalCourses - semesterCourses.length}',
                              //   style: TextStyle(
                              //     fontSize: 15,
                              //     fontWeight: FontWeight.w500,
                              //     color: Theme.of(context).primaryColor,
                              //     fontFamily: 'Ubuntu',
                              //   ),
                              // ),
                              IconButton(
                                  onPressed: (){
                                    // if (semester.totalCourses == 0) {
                                    //   selectCourseOptionsBottomSheet(context, semester);
                                    // }
                                    // else if(semester.totalCourses <= semester.numOfCourses) {
                                    //   Utils().showErrorSnackBar(
                                    //     'Error', 'Limit Already Completed...',
                                    //   );
                                    // }
                                    // else {
                                    //   if (semester.numOfElectiveCourses != 0) {
                                    //     _showAddCourseOptions(semester);
                                    //   }
                                    //   else {
                                    //     // addCourseBottomSheet(context, semester);
                                    //     showCourseSelectionBottomSheet(context, semester.totalCourses, semester.semesterName, 'compulsory');
                                    //   }
                                    // }
                                  },
                                  icon: Icon(CupertinoIcons.plus, color: Get.theme.primaryColor,)
                              )
                            ],
                          ),
                          const SizedBox(height: 2),

                          if(!controller.isLoading.value)
                            ... courseWidgets
                          // if (semesterCourses.isNotEmpty)
                          //   ...courseWidgets
                        ],
                      ),
                    );
                  }, childCount: controller.sectionList.length),
                );
              }
            }
          }),
        ],
      ),
    );
  }

  Future addTimeTableBottomSheet(BuildContext context) {
    controller.clearFields();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return buildTimeTableForm(context, addTimeTableKey, "Add", () {
          if (addTimeTableKey.currentState!.validate()) {
            controller.addTimeTable();
            Get.back();
          }
        });
      },
    );
  }

  Future editTimeTableBottomSheet(BuildContext context, TimetableEntry entry) {
    controller.updateTimeTableDetails(entry);
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return buildTimeTableForm(context, editTimeTableKey, "Edit", () {
          if (editTimeTableKey.currentState!.validate()) {
            controller.editTimeTable(entry);
            Get.back();
          }
        });
      },
    );
  }

  Widget buildTimeTableForm(BuildContext context, GlobalKey<FormState> formKey,
      String title, VoidCallback onSave) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.0,
        right: 16.0,
        top: 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$title TimeTable',
            style: TextStyle(
              fontFamily: 'Ubuntu',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Get.theme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Form(
            key: formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: controller.pickImage,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 200,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Obx(() {
                          if (controller.imageFile.value != null) {
                            return Image.file(
                              controller.imageFile.value!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            );
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.photo,
                                    color: Colors.grey.shade700, size: 30),
                                const Text('Click to select Image\nOptional',
                                    style: TextStyle(fontFamily: 'Ubuntu')),
                              ],
                            );
                          }
                        }),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.timeTableTitleController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      labelText: 'Title'),
                  validator: (value) =>
                      value!.isEmpty ? 'Title is required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.timeTableDescriptionController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  maxLines: 4,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      labelText: 'Description'),
                  validator: (value) =>
                      value!.isEmpty ? 'Description is required' : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onSave,
            child: Text(
              title,
              style: const TextStyle(
                  fontFamily: 'Ubuntu', fontSize: 20, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

}
