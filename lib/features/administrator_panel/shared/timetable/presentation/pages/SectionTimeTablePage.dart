import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:collection/collection.dart'; // for groupBy
import '../controllers/TimeTableController.dart';

class SectionTimeTablePage extends StatefulWidget {
  final String deptName;
  final String semester;
  final String section;

  const SectionTimeTablePage(
      {super.key, required this.deptName, required this.semester, required this.section});

  @override
  State<SectionTimeTablePage> createState() => _SectionTimeTablePageState();
}

class _SectionTimeTablePageState extends State<SectionTimeTablePage> {
  final TimeTableController controller = Get.find();

  @override
  void initState() {
    controller.showSectionTimeTable(widget.deptName, widget.semester, widget.section);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Group timetable entries by day

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.section} TimeTable'),
        backgroundColor: Get.theme.primaryColor,
      ),
      body: Obx(() {
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
          final groupedEntries = groupBy(
            controller.timeTableMap[widget.section] ?? [],
                (entry) => entry.day,
          );

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Iterate through the grouped days (Monday, Tuesday, etc.)
                  for (var day in groupedEntries.keys)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Day Header
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              day,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Get.theme.primaryColor,
                              ),
                            ),
                          ),
                          // Timetable entries for that day
                          ...groupedEntries[day]!.map((entry) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                const BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              border: Border.all(color: Get.theme.primaryColor),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Course and time info
                                Text(
                                  '${entry.courseName} (${entry.courseCode})',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Get.theme.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Teacher: ${entry.teacherName}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Room: ${entry.room}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Time: ${entry.timeSlot}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ))
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
