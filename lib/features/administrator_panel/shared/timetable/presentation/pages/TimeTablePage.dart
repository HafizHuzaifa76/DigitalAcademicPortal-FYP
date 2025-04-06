

import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../shared/presentation/widgets/ImageView.dart';
import '../../../sections/domain/entities/Section.dart';
import '../../../teachers/domain/entities/Teacher.dart';
import '../../domain/entities/TimeTable.dart';
import '../controllers/TimeTableController.dart';
import '../widgets/TimeTableWidget.dart';

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
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Get.theme.primaryColor,
      //   onPressed: () => addTimeTableBottomSheet(context),
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
      body: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          Obx(() {
            return SliverAppBar(
              expandedHeight: 150.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(bottom: controller.titlePadding.value),
                centerTitle: true,
                title: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('TimeTable Board', style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'Ubuntu', fontWeight: FontWeight.bold)),
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
                  child: const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 55,
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
                      Widget courseWidgets = Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Table(
                          border: TableBorder.all(color: Colors.grey),

                          children: [
                            // Header Row
                            TableRow(
                              decoration: BoxDecoration(color: Get.theme.primaryColor.withOpacity(0.9)),
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Course Name', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Course Code', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Teacher', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Day', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Time Slot', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Room', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              ],
                            ),

                            // Course Rows
                            ...(
                                (controller.timeTableMap[section.sectionName] == null ||
                                    controller.timeTableMap[section.sectionName]!.isEmpty)
                                    ? controller.coursesList.map((course) {
                                  return TableRow(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(course.courseName),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(course.courseCode ?? 'N/A'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          controller.selectedTeachers['${section.sectionName}-${course.courseName}']?.toString() ??
                                              'Not selected',
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Not selected'),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Not selected'),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Not selected'),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Not selected'),
                                      ),
                                    ],
                                  );
                                }).toList()
                                    : controller.timeTableMap[section.sectionName]!.map((entry) {
                                  return TableRow(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(entry.courseCode),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(entry.courseName ?? 'N/A'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(entry.teacherName),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(entry.day),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(entry.timeSlot),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(entry.room),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit, color: Colors.blue),
                                              onPressed: () {
                                                // _editEntry(context, entry);
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete, color: Colors.red),
                                              onPressed: () {
                                                // _confirmDelete(context, entry.id);
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList()
                            ),
                          ],
                        ),
                      );

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
                                IconButton(
                                  onPressed: () {
                                    // Check if any course in this section does not have a teacher
                                    bool hasUnassignedTeacher = controller.coursesList.any((course) {
                                      String key = '${section.sectionName}-${course.courseName}';
                                      print('$key : ${controller.selectedTeachers[key]}');
                                      return controller.selectedTeachers[key] == null || controller.selectedTeachers[key].toString() == 'Not Selected' || controller.selectedTeachers[key].toString().isEmpty;
                                    });

                                    print('hasUnassignedTeacher');
                                    print(hasUnassignedTeacher);
                                    if (hasUnassignedTeacher) {
                                      Utils().showErrorSnackBar(
                                          'Missing Teacher',
                                          'First assign teacher to courses then add timetable'
                                      );
                                    } else {
                                      // Proceed to show bottom sheet if all teachers are assigned
                                      showExcelBottomSheet(context, section.sectionName, [
                                        'Day',
                                        'Course Code',
                                        'Time Slot',
                                        'Room',
                                      ]);
                                    }
                                  },
                                  icon: Icon(CupertinoIcons.plus, color: Get.theme.primaryColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),

                            if (!controller.isLoading.value)
                              Scrollbar(
                                thumbVisibility: true,
                                trackVisibility: true,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                      width: Get.width * 2,
                                        child: courseWidgets
                                    )
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                    childCount: controller.sectionList.length,
                  ),
                );
              }
            }
          }),
        ],
      ),
    );
  }

  // Future addTimeTableBottomSheet(BuildContext context) {
  //   // controller.clearFields();
  //   return showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
  //     ),
  //     builder: (context) {
  //       return buildTimeTableForm(context, addTimeTableKey, "Add", () {
  //         if (addTimeTableKey.currentState!.validate()) {
  //           // controller.addTimeTable();
  //           Get.back();
  //         }
  //       });
  //     },
  //   );
  // }
  //
  // Future editTimeTableBottomSheet(BuildContext context, TimeTableEntry entry) {
  //   // controller.updateTimeTableDetails(entry);
  //   return showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
  //     ),
  //     builder: (context) {
  //       return buildTimeTableForm(context, editTimeTableKey, "Edit", () {
  //         if (editTimeTableKey.currentState!.validate()) {
  //           controller.editTimeTable(entry);
  //           Get.back();
  //         }
  //       });
  //     },
  //   );
  // }
  //
  // Widget buildTimeTableForm(BuildContext context, GlobalKey<FormState> formKey, String title, VoidCallback onSave) {
  //   return Padding(
  //     padding: EdgeInsets.only(
  //       bottom: MediaQuery.of(context).viewInsets.bottom,
  //       left: 16.0,
  //       right: 16.0,
  //       top: 16.0,
  //     ),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Text(
  //           '$title TimeTable',
  //           style: TextStyle(
  //             fontFamily: 'Ubuntu',
  //             fontSize: 22,
  //             fontWeight: FontWeight.bold,
  //             color: Get.theme.primaryColor,
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //         Form(
  //           key: formKey,
  //           child: Column(
  //             children: [
  //               GestureDetector(
  //                 onTap: controller.pickImage,
  //                 child: Stack(
  //                   alignment: Alignment.center,
  //                   children: [
  //                     Container(
  //                       height: 200,
  //                       width: double.maxFinite,
  //                       decoration: BoxDecoration(
  //                         color: Colors.grey[300],
  //                         borderRadius: BorderRadius.circular(8.0),
  //                       ),
  //                       child: Obx(() {
  //                         if (controller.imageFile.value != null) {
  //                           return Image.file(
  //                             controller.imageFile.value!,
  //                             height: 100,
  //                             width: 100,
  //                             fit: BoxFit.cover,
  //                           );
  //                         } else {
  //                           return Column(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               Icon(CupertinoIcons.photo,
  //                                   color: Colors.grey.shade700, size: 30),
  //                               const Text('Click to select Image\nOptional',
  //                                   style: TextStyle(fontFamily: 'Ubuntu')),
  //                             ],
  //                           );
  //                         }
  //                       }),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               TextFormField(
  //                 controller: controller.timeTableTitleController,
  //                 keyboardType: TextInputType.name,
  //                 textCapitalization: TextCapitalization.words,
  //                 decoration: InputDecoration(
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(10.0),
  //                     ),
  //                     enabledBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(10.0),
  //                       borderSide: const BorderSide(color: Colors.grey),
  //                     ),
  //                     labelText: 'Title'),
  //                 validator: (value) =>
  //                     value!.isEmpty ? 'Title is required' : null,
  //               ),
  //               const SizedBox(height: 10),
  //               TextFormField(
  //                 controller: controller.timeTableDescriptionController,
  //                 keyboardType: TextInputType.name,
  //                 textCapitalization: TextCapitalization.words,
  //                 maxLines: 4,
  //                 decoration: InputDecoration(
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(10.0),
  //                     ),
  //                     enabledBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(10.0),
  //                       borderSide: const BorderSide(color: Colors.grey),
  //                     ),
  //                     labelText: 'Description'),
  //                 validator: (value) =>
  //                     value!.isEmpty ? 'Description is required' : null,
  //               ),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(height: 20),
  //         ElevatedButton(
  //           onPressed: onSave,
  //           child: Text(
  //             title,
  //             style: const TextStyle(
  //                 fontFamily: 'Ubuntu', fontSize: 20, color: Colors.white),
  //           ),
  //         ),
  //         const SizedBox(height: 10),
  //       ],
  //     ),
  //   );
  // }

  Future showExcelBottomSheet(BuildContext context, String section, List<String> columns) {
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
              Text('Add Time Table', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, fontFamily: 'Ubuntu'),),
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
                )).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Important',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18, fontFamily: 'Ubuntu'),
              ),
              const Text(
                'Add all courses otherwise it will not accepted!',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontFamily: 'Ubuntu'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller.fetchTimeTableFromExcel(widget.semester, section).then((timetableEntries) {
                    if (timetableEntries.isNotEmpty) {
                      Get.to(()=> TimeTableWidget(
                        deptName: widget.deptName,
                        semester: widget.semester,
                        sectionName: section,
                        timetableEntries: timetableEntries,
                        onDelete: (id) {
                          setState(() {
                            timetableEntries.removeWhere((entry) => entry.id == id);
                          });
                        },
                        onEdit: (updatedEntry) {
                          setState(() {
                            int index = timetableEntries.indexWhere((entry) => entry.id == updatedEntry.id);
                            if (index != -1) {
                              timetableEntries[index] = updatedEntry;
                            }
                          });
                        },
                      ));
                    }
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
