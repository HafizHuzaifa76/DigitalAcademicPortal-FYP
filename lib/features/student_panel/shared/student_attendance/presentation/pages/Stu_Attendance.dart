import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';

class Stu_Attendance extends StatefulWidget {
  const Stu_Attendance({super.key});

  @override
  State<Stu_Attendance> createState() => _Stu_AttendanceState();
}

class _Stu_AttendanceState extends State<Stu_Attendance> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Map<String, double> attendanceData = {
    'Daily': 0.92,
    'Weekly': 0.87,
    'Monthly': 0.75,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildBarChart(double value) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(toY: value * 100, color: Colors.blueAccent, width: 20),
            ]),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        backgroundColor: Colors.green
      ),
      body: Column(
        children: [
          Container(
            color: Get.theme.primaryColor,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.indigo,
              labelColor: Colors.indigo,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Daily'),
                Tab(text: 'Weekly'),
                Tab(text: 'Monthly'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: ['Daily', 'Weekly', 'Monthly'].map((key) {
                double value = attendanceData[key]!;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      CircularPercentIndicator(
                        radius: 100,
                        lineWidth: 13,
                        animation: true,
                        percent: value,
                        center: Text(
                          "${(value * 100).toStringAsFixed(1)}%",
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        footer: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            "$key Attendance",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.indigo,
                        backgroundColor: Colors.indigo.shade100,
                      ),
                      const SizedBox(height: 32),
                      _buildBarChart(value),
                      const SizedBox(height: 16),
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Attendance Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text("Classes Attended: ${(value * 30).round()}/30"),
                              Text("Absences: ${(30 - value * 30).round()}"),
                              Text("Overall Percentage: ${(value * 100).toStringAsFixed(1)}%"),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
