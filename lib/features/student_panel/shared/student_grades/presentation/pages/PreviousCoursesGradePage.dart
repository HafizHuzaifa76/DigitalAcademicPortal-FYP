import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../manager/StudentGradeController.dart';

class PreviousCoursesGradePage extends GetView<StudentGradeController> {
  const PreviousCoursesGradePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load previous grades when this view is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.previousGradesList.isEmpty) {
        controller.loadPreviousGrades();
      }
    });

    return Obx(() {
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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Table(
                border: TableBorder.all(color: Colors.grey),
                columnWidths: const {
                  0: FlexColumnWidth(1.5), // Course Code
                  1: FlexColumnWidth(2), // Course Name
                  2: FlexColumnWidth(1), // Credit Hours
                  3: FlexColumnWidth(1), // Sessional
                  4: FlexColumnWidth(1), // Final
                  5: FlexColumnWidth(1), // Total
                  6: FlexColumnWidth(1), // Grade
                  7: FlexColumnWidth(1), // GPA
                  8: FlexColumnWidth(1), // Status
                  9: FlexColumnWidth(1), // Semester
                  10: FlexColumnWidth(1.5), // Remarks
                },
                children: [
                  _buildTableHeader([
                    'Course Code',
                    'Course Name',
                    'Credit Hours',
                    'Sessional',
                    'Final',
                    'Total',
                    'Grade',
                    'GPA',
                    'Status',
                    'Semester',
                    'Remarks'
                  ]),
                  ...controller.previousGradesList
                      .map((grade) => TableRow(
                            children: [
                              _buildTableCell(grade.courseCode),
                              _buildTableCell(grade.course),
                              _buildTableCell(grade.credithour.toString()),
                              _buildTableCell(grade.sessionalMarks.toString()),
                              _buildTableCell(grade.finalMarks.toString()),
                              _buildTableCell(grade.totalMarks.toString()),
                              _buildTableCell(grade.grade),
                              _buildTableCell(grade.gpa.toStringAsFixed(2)),
                              _buildTableCell(grade.status),
                              _buildTableCell(grade.semester),
                              _buildTableCell(grade.remarks ?? '-'),
                            ],
                          ))
                      .toList(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
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
                      'View Transcript',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _exportPDF(controller),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00796B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      'Export PDF',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
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
                  'Course Code',
                  'Course Name',
                  'Credit Hours',
                  'Sessional',
                  'Final',
                  'Total',
                  'Grade',
                  'GPA',
                  'Status',
                  'Semester',
                  'Remarks'
                ],
                data: controller.previousGradesList
                    .map((grade) => [
                          grade.courseCode,
                          grade.course,
                          grade.credithour.toString(),
                          grade.sessionalMarks.toString(),
                          grade.finalMarks.toString(),
                          grade.totalMarks.toString(),
                          grade.grade,
                          grade.gpa.toStringAsFixed(2),
                          grade.status,
                          grade.semester,
                          grade.remarks ?? '-',
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Academic Transcript',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  border: TableBorder.all(color: Colors.black26),
                  columnWidths: const {
                    0: FlexColumnWidth(1.5), // Course Code
                    1: FlexColumnWidth(2), // Course Name
                    2: FlexColumnWidth(1), // Credit Hours
                    3: FlexColumnWidth(1), // Sessional
                    4: FlexColumnWidth(1), // Final
                    5: FlexColumnWidth(1), // Total
                    6: FlexColumnWidth(1), // Grade
                    7: FlexColumnWidth(1), // GPA
                    8: FlexColumnWidth(1), // Status
                    9: FlexColumnWidth(1), // Semester
                    10: FlexColumnWidth(1.5), // Remarks
                  },
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(color: Color(0xFFE0F2F1)),
                      children: [
                        'Course Code',
                        'Course Name',
                        'Credit Hours',
                        'Sessional',
                        'Final',
                        'Total',
                        'Grade',
                        'GPA',
                        'Status',
                        'Semester',
                        'Remarks'
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
                                _buildTableCell(grade.courseCode),
                                _buildTableCell(grade.course),
                                _buildTableCell(grade.credithour.toString()),
                                _buildTableCell(
                                    grade.sessionalMarks.toString()),
                                _buildTableCell(grade.finalMarks.toString()),
                                _buildTableCell(grade.totalMarks.toString()),
                                _buildTableCell(grade.grade),
                                _buildTableCell(grade.gpa.toStringAsFixed(2)),
                                _buildTableCell(grade.status),
                                _buildTableCell(grade.semester),
                                _buildTableCell(grade.remarks ?? '-'),
                              ],
                            ))
                        .toList(),
                  ],
                ),
              ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text, textAlign: TextAlign.center),
    );
  }
}
