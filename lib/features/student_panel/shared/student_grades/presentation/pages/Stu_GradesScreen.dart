import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:flutter/material.dart';

class GradeScreen extends StatefulWidget {
  const GradeScreen({super.key});

  @override
  State<GradeScreen> createState() => _GradeScreenState();
}

class _GradeScreenState extends State<GradeScreen> {
  bool isCurrentSemester = true;
  String selectedSubject = 'CS-4205-Entrepreneurship';

  final List<String> subjects = [
    'CS-4201-Data Structures',
    'CS-4202-OOP',
    'CS-4203-DBMS',
    'CS-4204-OS',
    'CS-4205-Entrepreneurship',
  ];

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
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCurrentSemester ? const Color(0xFF00796B) : Colors.white,
                    foregroundColor: isCurrentSemester ? Colors.white : Colors.black,
                    shape: const RoundedRectangleBorder(),
                  ),
                  onPressed: () => setState(() => isCurrentSemester = true),
                  child: const Text('Before Result Submission'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !isCurrentSemester ? const Color(0xFF00796B) : Colors.white,
                    foregroundColor: !isCurrentSemester ? Colors.white : Colors.black,
                    shape: const RoundedRectangleBorder(),
                  ),
                  onPressed: () => setState(() => isCurrentSemester = false),
                  child: const Text('After Result Submission'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: isCurrentSemester
                ? _buildCurrentSemesterView()
                : _buildPreviousSemesterView(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    pageBuilder: (_, __, ___) => const TranscriptScreen(),
                    transitionsBuilder: (_, animation, __, child) {
                      return SlideTransition(
                        position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(animation),
                        child: child,
                      );
                    },
                  ),
                );
              },
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
      ),
    );
  }

  Widget _buildCurrentSemesterView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('SELECT SUBJECT', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: selectedSubject,
          items: subjects
              .map((subj) => DropdownMenuItem(value: subj, child: Text(subj)))
              .toList(),
          onChanged: (val) => setState(() => selectedSubject = val!),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('ASSIGNMENTS'),
        _buildGradeRow('A1', 10, 9),
        _buildSectionTitle('QUIZZES'),
        _buildGradeRow('Q1', 10, 8),
        _buildSectionTitle('MID TERM'),
        _buildGradeRow('Mid Term', 30, 25),
        _buildSectionTitle('PRESENTATION'),
        _buildGradeRow('Presentation', 10, 10),
        _buildSectionTitle('FINAL TERM'),
        _buildGradeRow('Final Term', 40, 35),
      ],
    );
  }

  Widget _buildPreviousSemesterView() {
    final List<Map<String, String>> subjects = [
      {'subject': 'CS-4201', 'sessional': '20', 'final': '60', 'total': '80', 'eligible': 'Yes', 'passed': 'Yes'},
      {'subject': 'CS-4202', 'sessional': '18', 'final': '55', 'total': '73', 'eligible': 'Yes', 'passed': 'Yes'},
    ];

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
        },
        children: [
          _buildTableHeader(['Subject', 'Sessional', 'Final', 'Total', 'Eligibility', 'Passed']),
          ...subjects.map((entry) => TableRow(
            children: entry.values.map((val) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(val, textAlign: TextAlign.center),
            )).toList(),
          )),
        ],
      ),
    );
  }

  Widget _buildGradeRow(String title, int total, int obtained) {
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
          Text('Total: $total'),
          Text('Obtained: $obtained'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  TableRow _buildTableHeader(List<String> headers) {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFE0F2F1)),
      children: headers.map((text) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      )).toList(),
    );
  }
}

class TranscriptScreen extends StatelessWidget {
  const TranscriptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> transcriptData = [
      {"subject": "CS-4201", "sessional": "20", "final": "60", "total": "80", "grade": "A", "remarks": "Excellent"},
      {"subject": "CS-4202", "sessional": "18", "final": "55", "total": "73", "grade": "B+", "remarks": "Good"},
      {"subject": "CS-4203", "sessional": "15", "final": "50", "total": "65", "grade": "B", "remarks": "Average"},
    ];

    const gpa = "3.45";
    const cgpa = "3.39";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00796B),
        title: const Text('Transcript'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.05,
            child: Center(
              child: Text(
                "",
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
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
                  },
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(color: Color(0xFFE0F2F1)),
                      children: [
                        'Subject', 'Sessional', 'Final', 'Total', 'Grade', 'Remarks'
                      ].map((e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(e, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      )).toList(),
                    ),
                    ...transcriptData.map((row) {
                      return TableRow(
                        children: row.values.map((val) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(val, textAlign: TextAlign.center),
                        )).toList(),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("GPA:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(gpa),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("CGPA:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(cgpa),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () async {
                    final pdf = pw.Document();

                    pdf.addPage(
                      pw.Page(
                        pageFormat: PdfPageFormat.a4,
                        build: (pw.Context context) {
                          return pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('Academic Transcript', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 20),
                              pw.Table.fromTextArray(
                                headers: ['Subject', 'Sessional', 'Final', 'Total', 'Grade', 'Remarks'],
                                data: [
                                  ['CS-4201', '20', '60', '80', 'A', 'Excellent'],
                                  ['CS-4202', '18', '55', '73', 'B+', 'Good'],
                                  ['CS-4203', '15', '50', '65', 'B', 'Average'],
                                ],
                              ),
                              pw.SizedBox(height: 20),
                              pw.Text('GPA: 3.45'),
                              pw.Text('CGPA: 3.39'),
                            ],
                          );
                        },
                      ),
                    );

                    // Show PDF preview and allow printing/saving
                    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
                  },

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
}
