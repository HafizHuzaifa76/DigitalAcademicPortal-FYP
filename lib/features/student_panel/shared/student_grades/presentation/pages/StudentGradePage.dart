import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../manager/StudentGradeController.dart';
import '../../../student_courses/domain/entities/StudentCourse.dart';

class StudentGradePage extends GetView<StudentGradeController> {
  const StudentGradePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        title: const Text('Grades'),
        centerTitle: true,
        elevation: 4,
        backgroundColor: const Color(0xFF00796B),
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
        }

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.isCurrentSemester.value
                          ? const Color(0xFF00796B)
                          : Colors.white,
                      foregroundColor: controller.isCurrentSemester.value
                          ? Colors.white
                          : Colors.black,
                      shape: const RoundedRectangleBorder(),
                    ),
                    onPressed: () => controller.setCurrentSemester(true),
                    child: const Text('Current Semester'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !controller.isCurrentSemester.value
                          ? const Color(0xFF00796B)
                          : Colors.white,
                      foregroundColor: !controller.isCurrentSemester.value
                          ? Colors.white
                          : Colors.black,
                      shape: const RoundedRectangleBorder(),
                    ),
                    onPressed: () => controller.setCurrentSemester(false),
                    child: const Text('Previous Courses'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: controller.isCurrentSemester.value
                  ? _buildCurrentSemesterView()
                  : _buildPreviousSemesterView(),
            ),
            if (!controller.isCurrentSemester.value)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () => _showTranscript(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00796B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text(
                    'Generate Transcript',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildCurrentSemesterView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('SELECT COURSE',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButton<StudentCourse>(
          value: controller.selectedCourse.value,
          items: controller.studentCourses
              .map((course) => DropdownMenuItem(
                  value: course, child: Text(course.courseName)))
              .toList(),
          onChanged: (val) => controller.updateSelectedCourse(val!),
        ),
        const SizedBox(height: 20),
        ...controller.categories
            .map((category) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(category.toUpperCase()),
                    ...controller.getGradesByCategory(category).map((grade) =>
                        _buildGradeRow(
                            grade.id, grade.totalMarks, grade.marks)),
                  ],
                ))
            .toList(),
      ],
    );
  }

  Widget _buildPreviousSemesterView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Table(
        border: TableBorder.all(color: Colors.grey),
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(),
          2: FlexColumnWidth(),
          3: FlexColumnWidth(),
          4: FlexColumnWidth(),
          5: FlexColumnWidth(),
          6: FlexColumnWidth(),
        },
        children: [
          _buildTableHeader([
            'Course',
            'Sessional',
            'Final',
            'Total',
            'Eligibility',
            'Status',
            'Semester'
          ]),
          ...controller.previousGradesList
              .map((grade) => TableRow(
                    children: [
                      _buildTableCell(grade.course),
                      _buildTableCell(grade.sessionalMarks.toString()),
                      _buildTableCell(grade.finalMarks.toString()),
                      _buildTableCell(grade.totalMarks.toString()),
                      _buildTableCell(grade.eligibility),
                      _buildTableCell(grade.status),
                      _buildTableCell(grade.semester),
                    ],
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildGradeRow(String title, double total, double obtained) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('Total: ${total.toString()}'),
          Text('Obtained: ${obtained.toString()}'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  TableRow _buildTableHeader(List<String> headers) {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFE0F2F1)),
      children:
          headers.map((text) => _buildTableCell(text, isHeader: true)).toList(),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: isHeader ? const TextStyle(fontWeight: FontWeight.bold) : null,
        textAlign: TextAlign.center,
      ),
    );
  }

  void _showTranscript(BuildContext context) {
    Get.to(() => TranscriptView(controller: controller));
  }
}

class TranscriptView extends StatelessWidget {
  final StudentGradeController controller;

  const TranscriptView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00796B),
        title: const Text('Transcript'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Academic Transcript',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Table(
                  border: TableBorder.all(color: Colors.black26),
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(),
                    2: FlexColumnWidth(),
                    3: FlexColumnWidth(),
                    4: FlexColumnWidth(),
                    5: FlexColumnWidth(),
                    6: FlexColumnWidth(),
                  },
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(color: Color(0xFFE0F2F1)),
                      children: [
                        'Course',
                        'Sessional',
                        'Final',
                        'Total',
                        'Eligibility',
                        'Status',
                        'Semester'
                      ]
                          .map((e) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(e,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center),
                              ))
                          .toList(),
                    ),
                    ...controller.previousGradesList
                        .map((grade) => TableRow(
                              children: [
                                _buildTableCell(grade.course),
                                _buildTableCell(
                                    grade.sessionalMarks.toString()),
                                _buildTableCell(grade.finalMarks.toString()),
                                _buildTableCell(grade.totalMarks.toString()),
                                _buildTableCell(grade.eligibility),
                                _buildTableCell(grade.status),
                                _buildTableCell(grade.semester),
                              ],
                            ))
                        .toList(),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("GPA:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(controller.calculateGPA().toStringAsFixed(2)),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _exportPDF(controller),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("Export as PDF"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00796B),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text, textAlign: TextAlign.center),
    );
  }

  Future<void> _exportPDF(StudentGradeController controller) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Academic Transcript',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: [
                  'Course',
                  'Sessional',
                  'Final',
                  'Total',
                  'Eligibility',
                  'Status',
                  'Semester'
                ],
                data: controller.previousGradesList
                    .map((grade) => [
                          grade.course,
                          grade.sessionalMarks.toString(),
                          grade.finalMarks.toString(),
                          grade.totalMarks.toString(),
                          grade.eligibility,
                          grade.status,
                          grade.semester,
                        ])
                    .toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Text('GPA: ${controller.calculateGPA().toStringAsFixed(2)}'),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
