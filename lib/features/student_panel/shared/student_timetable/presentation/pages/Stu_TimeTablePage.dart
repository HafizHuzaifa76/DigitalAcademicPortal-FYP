import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../shared/domain/entities/TimeTable.dart';
import '../controllers/StudentTimetableController.dart';
import '../bindings/StudentTimetableBinding.dart';

class Stu_TimeTablePage extends StatefulWidget {
  const Stu_TimeTablePage({Key? key}) : super(key: key);

  @override
  State<Stu_TimeTablePage> createState() => _Stu_TimeTablePageState();
}

class _Stu_TimeTablePageState extends State<Stu_TimeTablePage> {
  late final StudentTimetableController timetableController;

  @override
  void initState() {
    super.initState();
    StudentTimetableBinding().dependencies();
    timetableController = Get.find<StudentTimetableController>();
    timetableController.loadStudentTimetable();
  }

  /// Organizes timetable into a day -> slot -> entry map
  Map<String, Map<String, TimeTableEntry?>> organizeTimetable(
      List<TimeTableEntry> entries) {
    final Map<String, Map<String, TimeTableEntry?>> timetable = {};

    // Get unique days & slots
    final days = entries.map((e) => e.day.trim()).toSet().toList();
    final slots = entries.map((e) => e.timeSlot.trim()).toSet().toList();

    // Sort days in Monday → Sunday order
    final dayOrder = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    days.sort((a, b) => dayOrder.indexOf(a) != -1 && dayOrder.indexOf(b) != -1
        ? dayOrder.indexOf(a).compareTo(dayOrder.indexOf(b))
        : a.compareTo(b));

    // Sort slots in ascending time order (lexical fallback)
    slots.sort();

    // Initialize timetable
    for (String day in days) {
      timetable[day] = {};
      for (String slot in slots) {
        timetable[day]![slot] = null;
      }
    }

    // Fill timetable
    for (var entry in entries) {
      final day = entry.day.trim();
      final slot = entry.timeSlot.trim();
      if (timetable.containsKey(day) && timetable[day]!.containsKey(slot)) {
        timetable[day]![slot] = entry;
      }
    }

    return timetable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Timetable'),
        flexibleSpace: Container(
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
        ),
      ),
      body: Obx(() {
        if (timetableController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (timetableController.timeTableEntries.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.schedule_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No timetable available',
                    style: TextStyle(fontSize: 18, color: Colors.grey)),
              ],
            ),
          );
        }

        final timetable =
            organizeTimetable(timetableController.timeTableEntries);
        final weekDays = timetable.keys.toList();
        final timeSlots =
            weekDays.isNotEmpty ? timetable[weekDays.first]!.keys.toList() : [];

        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Weekly Schedule',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Get.theme.primaryColor,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: weekDays.map((day) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Get.theme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  color: Get.theme.primaryColor, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                day,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Get.theme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Only show slots that actually have a class
                        ...timeSlots
                            .where((slot) => timetable[day]![slot] != null)
                            .map((slot) {
                          final entry = timetable[day]![slot]!;
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  width: 1),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color:
                                        Get.theme.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    slot,
                                    style: TextStyle(
                                      color: Get.theme.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.courseName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Teacher: ${entry.teacherName}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Room: ${entry.room}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),

                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              _buildWeekendSection(),
              const SizedBox(height: 16),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildWeekendSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekend',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Get.theme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildWeekendDay('Saturday'),
              const SizedBox(width: 16),
              _buildWeekendDay('Sunday'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekendDay(String day) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.theme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(Icons.weekend, color: Get.theme.primaryColor, size: 24),
            const SizedBox(height: 8),
            Text(
              day,
              style: TextStyle(
                color: Get.theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'No Classes',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
