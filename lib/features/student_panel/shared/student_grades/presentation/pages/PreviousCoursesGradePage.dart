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
    final theme = Theme.of(context);
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

      // Group grades by semester
      final gradesBySemester = <String, List<dynamic>>{};
      for (var grade in controller.previousGradesList) {
        gradesBySemester.putIfAbsent(grade.semester, () => []).add(grade);
      }
      // Sort semesters (assuming format like 'I', 'II', ... or '1', '2', ...)
      final sortedSemesters = gradesBySemester.keys.toList()
        ..sort((a, b) {
          // Try to parse as int, fallback to string compare
          final aNum = int.tryParse(a.replaceAll(RegExp(r'[^0-9]'), ''));
          final bNum = int.tryParse(b.replaceAll(RegExp(r'[^0-9]'), ''));
          if (aNum != null && bNum != null) return aNum.compareTo(bNum);
          return a.compareTo(b);
        });

      return Container(
        color: const Color(0xFFF8F9FA),
        child: Column(
          children: [
            Expanded(
              child: controller.previousGradesList.isEmpty
                  ? Center(
                      child: Text(
                        'No previous grades found.',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18,
                          fontFamily: 'Ubuntu',
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: sortedSemesters.length,
                      itemBuilder: (context, semIndex) {
                        final semester = sortedSemesters[semIndex];
                        final grades = gradesBySemester[semester]!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                semester,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                  fontFamily: 'Ubuntu',
                                ),
                              ),
                            ),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final isWide = constraints.maxWidth > 700;
                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isWide ? 2 : 1,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: isWide ? 2.5 : 1.07,
                                  ),
                                  itemCount: grades.length,
                                  itemBuilder: (context, index) {
                                    final grade = grades[index];
                                    return _buildGradeCard(
                                        context, grade, theme);
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      },
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
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ).copyWith(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color?>((states) {
                          return null;
                        }),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.primaryColor,
                              const Color(0xFF1B7660)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          child: const Text(
                            'View Transcript',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _exportPDF(controller),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ).copyWith(
                        elevation: WidgetStateProperty.all(0),
                        backgroundColor:
                            WidgetStateProperty.resolveWith<Color?>((states) {
                          return null;
                        }),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.primaryColor,
                              const Color(0xFF1B7660)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          child: const Text(
                            'Export PDF',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildGradeCard(BuildContext context, dynamic grade, ThemeData theme) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Gradient header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.primaryColor, const Color(0xFF1B7660)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  grade.courseCode,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Ubuntu',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  grade.course,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontFamily: 'Ubuntu',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    _iconText(Icons.school, 'Credit Hours',
                        grade.credithour.toString()),
                    _iconText(
                        Icons.assignment,
                        'Sessional',
                        (grade.sessionalMarks % 1 == 0)
                            ? grade.sessionalMarks.toStringAsFixed(0)
                            : grade.sessionalMarks.toStringAsFixed(2)),
                    _iconText(
                      Icons.assignment_turned_in,
                      'Final',
                      (grade.finalMarks % 1 == 0)
                          ? grade.finalMarks.toStringAsFixed(0)
                          : grade.finalMarks.toStringAsFixed(2),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _iconText(
                      Icons.calculate,
                      'Total',
                      (grade.totalMarks % 1 == 0)
                          ? grade.totalMarks.toStringAsFixed(0)
                          : grade.totalMarks.toStringAsFixed(2),
                    ),
                    _iconText(Icons.grade, 'Grade', grade.grade),
                    _iconText(Icons.star, 'GPA', grade.gpa.toStringAsFixed(2)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _iconText(Icons.verified, 'Status', grade.status),
                    _iconText(Icons.calendar_today, 'Semester', grade.semester),
                  ],
                ),
                const SizedBox(height: 10),
                if (grade.remarks != null && grade.remarks.trim().isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.comment, color: theme.primaryColor, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          grade.remarks,
                          style: const TextStyle(
                              fontFamily: 'Ubuntu', fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconText(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Get.theme.primaryColor, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
                fontSize: 12, color: Colors.black54, fontFamily: 'Ubuntu'),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
          ),
        ],
      ),
    );
  }

  void _showTranscript(BuildContext context) {
    Get.to(() => TranscriptView(controller: controller));
  }

  Future<void> _exportPDF(StudentGradeController controller) async {
    final pdf = pw.Document();
    final logo = await imageFromAssetBundle('assets/images/DAP logo.png');
    final themeColor = PdfColor.fromInt(0xFF145849);

    // Group grades by semester
    final gradesBySemester = <String, List<dynamic>>{};
    for (var grade in controller.previousGradesList) {
      gradesBySemester.putIfAbsent(grade.semester, () => []).add(grade);
    }
    final sortedSemesters = gradesBySemester.keys.toList()
      ..sort((a, b) {
        final aNum = int.tryParse(a.replaceAll(RegExp(r'[^0-9]'), ''));
        final bNum = int.tryParse(b.replaceAll(RegExp(r'[^0-9]'), ''));
        if (aNum != null && bNum != null) return aNum.compareTo(bNum);
        return a.compareTo(b);
      });

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        build: (pw.Context context) {
          return [
            // App Logo and Name
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Container(
                  width: 60,
                  height: 60,
                  decoration: pw.BoxDecoration(
                    borderRadius: pw.BorderRadius.circular(30),
                    border: pw.Border.all(color: themeColor, width: 2),
                  ),
                  child: pw.ClipRRect(
                    horizontalRadius: 30,
                    verticalRadius: 30,
                    child: pw.Image(logo, fit: pw.BoxFit.cover),
                  ),
                ),
                pw.SizedBox(width: 16),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Digital Academic Portal',
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          color: themeColor,
                        )),
                    pw.Text('Academic Transcript',
                        style: pw.TextStyle(
                          fontSize: 16,
                          color: PdfColors.grey700,
                        )),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 18),
            // Semester-wise tables
            ...sortedSemesters.expand((semester) {
              final grades = gradesBySemester[semester]!;
              final sgpa = _calculateSGPA(grades);
              return [
                pw.Container(
                  margin: const pw.EdgeInsets.only(top: 16, bottom: 6),
                  child: pw.Text(
                    semester,
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: themeColor,
                    ),
                  ),
                ),
                pw.Table.fromTextArray(
                  headers: [
                    'Course Code',
                    'Course Name',
                    'Credit Hours',
                    'Grade',
                    'GPA',
                    'Status',
                  ],
                  data: grades
                      .map((grade) => [
                            grade.courseCode,
                            grade.course,
                            grade.credithour.toString(),
                            grade.grade,
                            grade.gpa.toStringAsFixed(2),
                            grade.status,
                          ])
                      .toList(),
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                  headerDecoration: pw.BoxDecoration(
                    color: themeColor,
                  ),
                  cellStyle: const pw.TextStyle(fontSize: 11),
                  cellAlignment: pw.Alignment.center,
                  border: pw.TableBorder(
                    horizontalInside: pw.BorderSide(color: PdfColors.grey300),
                    bottom: pw.BorderSide(color: PdfColors.grey400),
                  ),
                  cellAlignments: {
                    0: pw.Alignment.center,
                    1: pw.Alignment.centerLeft,
                    2: pw.Alignment.center,
                    3: pw.Alignment.center,
                    4: pw.Alignment.center,
                    5: pw.Alignment.center,
                  },
                ),
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(top: 4, bottom: 12),
                  child: pw.Text(
                    'SGPA: ${sgpa.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      color: themeColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ];
            }),
            pw.Divider(color: PdfColors.grey400, thickness: 0.7),
            pw.SizedBox(height: 8),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  'CGPA: ${controller.calculateGPA().toStringAsFixed(2)}',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: themeColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  double _calculateSGPA(List<dynamic> grades) {
    if (grades.isEmpty) return 0.0;
    double totalGpa = 0;
    for (var grade in grades) {
      totalGpa += grade.gpa;
    }
    return totalGpa / grades.length;
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
