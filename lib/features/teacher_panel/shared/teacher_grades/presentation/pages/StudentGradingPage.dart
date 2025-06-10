import 'package:flutter/material.dart';
import '../../domain/entities/Student.dart';
import '../../domain/entities/TeacherGrade.dart';

class StudentGradingPage extends StatefulWidget {
  final String assignmentId;
  final String title;
  final int totalMarks;

  const StudentGradingPage({
    super.key,
    required this.assignmentId,
    required this.title,
    required this.totalMarks,
  });

  @override
  State<StudentGradingPage> createState() => _StudentGradingPageState();
}

class _StudentGradingPageState extends State<StudentGradingPage> {
  List<Student> students = [];
  List<TeacherGrade> grades = [];
  bool _areAllStudentsSelected = false;

  @override
  void initState() {
    super.initState();
    _initializeStudents();
  }

  void _initializeStudents() {
    // Sample student data
    students = [
      Student(
        id: '1',
        name: 'Abdul Sami',
        rollNumber: 'CS-001',
        email: 'abdul.sami@example.com',
        enrolledCourseIds: ['1', '2'],
        obtainedMarks: 0,
      ),
      Student(
        id: '2',
        name: 'Aleena Mazhar',
        rollNumber: 'CS-002',
        email: 'aleena.mazhar@example.com',
        enrolledCourseIds: ['1', '3'],
        obtainedMarks: 0,
      ),
      Student(
        id: '3',
        name: 'Alishaz Imtiaz Ali',
        rollNumber: 'CS-003',
        email: 'alishaz.imtiaz@example.com',
        enrolledCourseIds: ['1', '4'],
        obtainedMarks: 0,
      ),
      Student(
        id: '4',
        name: 'Faisal Ilyas',
        rollNumber: 'CS-004',
        email: 'faisal.ilyas@example.com',
        enrolledCourseIds: ['1', '2'],
        obtainedMarks: 0,
      ),
      Student(
        id: '5',
        name: 'Ibrar Ahmed',
        rollNumber: 'CS-005',
        email: 'ibrar.ahmed@example.com',
        enrolledCourseIds: ['1', '5'],
        obtainedMarks: 0,
      ),
      Student(
        id: '6',
        name: 'Kausar Fatima',
        rollNumber: 'CS-006',
        email: 'kausar.fatima@example.com',
        enrolledCourseIds: ['1', '2'],
        obtainedMarks: 0,
      ),
      Student(
        id: '7',
        name: 'Mahnoor Fatima',
        rollNumber: 'CS-007',
        email: 'mahnoor.fatima@example.com',
        enrolledCourseIds: ['1', '3'],
        obtainedMarks: 0,
      ),
      Student(
        id: '8',
        name: 'Muhammad Talha',
        rollNumber: 'CS-008',
        email: 'muhammad.talha@example.com',
        enrolledCourseIds: ['1', '4'],
        obtainedMarks: 0,
      ),
      Student(
        id: '9',
        name: 'Noor Fatima',
        rollNumber: 'CS-009',
        email: 'noor.fatima@example.com',
        enrolledCourseIds: ['1', '5'],
        obtainedMarks: 0,
      ),
      Student(
        id: '10',
        name: 'Omar Khan',
        rollNumber: 'CS-010',
        email: 'omar.khan@example.com',
        enrolledCourseIds: ['1', '2'],
        obtainedMarks: 0,
      ),
      Student(
        id: '11',
        name: 'Saad Hussain',
        rollNumber: 'CS-011',
        email: 'saad.hussain@example.com',
        enrolledCourseIds: ['1', '3'],
        obtainedMarks: 0,
      ),
      Student(
        id: '12',
        name: 'Sabeen Noor',
        rollNumber: 'CS-012',
        email: 'sabeen.noor@example.com',
        enrolledCourseIds: ['1', '4'],
        obtainedMarks: 0,
      ),
      Student(
        id: '13',
        name: 'Usman Ali',
        rollNumber: 'CS-013',
        email: 'usman.ali@example.com',
        enrolledCourseIds: ['1', '5'],
        obtainedMarks: 0,
      ),
      Student(
        id: '14',
        name: 'Waqas Ahmed',
        rollNumber: 'CS-014',
        email: 'waqas.ahmed@example.com',
        enrolledCourseIds: ['1', '2'],
        obtainedMarks: 0,
      ),
      Student(
        id: '15',
        name: 'Zainab Fatima',
        rollNumber: 'CS-015',
        email: 'zainab.fatima@example.com',
        enrolledCourseIds: ['1', '3'],
        obtainedMarks: 0,
      ),
    ];

    // Initialize any existing grades
    // This would typically be loaded from a database
    grades = [];
  }

  void _saveGrades() {
    // Create TeacherGrade objects for each student
    List<TeacherGrade> newGrades = [];
    
    for (var student in students) {
      if (student.obtainedMarks != null && student.obtainedMarks! > 0) {
        newGrades.add(
          TeacherGrade(
            id: DateTime.now().millisecondsSinceEpoch.toString() + student.id,
            courseId: '1', // Replace with actual course ID
            courseName: 'Sample Course', // Replace with actual course name
            sectionClass: 'A1', // Replace with actual section
            studentId: student.id,
            studentName: student.name,
            obtainedMarks: student.obtainedMarks!,
            totalMarks: widget.totalMarks.toDouble(),
            category: 'Assignment', // Replace with actual category
            title: widget.title,
            date: DateTime.now().toString().split(' ')[0],
            semester: 'Fall 2024', // Replace with actual semester
            isSubmitted: true,
          ),
        );
      }
    }

    // Here, you would typically save these grades to a database
    setState(() {
      grades = newGrades;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Grades saved successfully')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    int turnedIn = students.where((s) => s.obtainedMarks != null && s.obtainedMarks! > 0).length;
    
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          widget.title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: const Color(0xFF2D2D2D),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'download',
                child: Text('Download', style: TextStyle(color: Colors.white)),
              ),
              const PopupMenuItem(
                value: 'copy',
                child: Text('Copy link', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              color: const Color(0xFF1F1F1F),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade700),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: PopupMenuButton<String>(
                      color: const Color(0xFF3D3D3D),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${widget.totalMarks} points',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, color: Colors.white),
                        ],
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: '${widget.totalMarks}',
                          child: Text(
                            '${widget.totalMarks} points',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const PopupMenuItem(
                          value: '50',
                          child: Text('50 points', style: TextStyle(color: Colors.white)),
                        ),
                        const PopupMenuItem(
                          value: '25',
                          child: Text('25 points', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: const Color(0xFF212121),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Text(
                    'Instructions',
                    style: TextStyle(color: Colors.white60),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Student Work',
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 2,
                        width: 100,
                        color: Colors.blue,
                        margin: const EdgeInsets.only(top: 4),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '$turnedIn',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Turned in',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const Spacer(),
                  Text(
                    '${students.length}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Assigned',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Submissions closed Aug 24, 2024, 11:59 PM',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFF3D3D3D)),
            ListTile(
              tileColor: const Color(0xFF1F1F1F),
              leading: Checkbox(
                value: _areAllStudentsSelected,
                checkColor: Colors.black,
                fillColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.blue;
                  }
                  return Colors.grey;
                }),
                onChanged: (value) {
                  setState(() {
                    _areAllStudentsSelected = value ?? false;
                    for (var student in students) {
                      student.isSelected = _areAllStudentsSelected;
                    }
                  });
                },
              ),
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade200,
                    child: const Icon(Icons.people, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'All students',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              color: const Color(0xFF1F1F1F),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: const Row(
                children: [
                  SizedBox(width: 72),
                  Text(
                    'ASSIGNED',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return Container(
                    color: index % 2 == 0 ? const Color(0xFF1A1A1A) : const Color(0xFF212121),
                    child: ListTile(
                      dense: true,
                      leading: Checkbox(
                        value: student.isSelected,
                        checkColor: Colors.black,
                        fillColor: MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors.blue;
                          }
                          return Colors.grey;
                        }),
                        onChanged: (value) {
                          setState(() {
                            student.isSelected = value ?? false;
                            _updateAllSelectedState();
                          });
                        },
                      ),
                      title: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.primaries[index % Colors.primaries.length],
                            child: Text(
                              student.name.substring(0, 1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              student.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            width: 70,
                            height: 36,
                            constraints: const BoxConstraints(maxWidth: 70),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Points',
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                isDense: true,
                                fillColor: Color(0xFF2D2D2D),
                                filled: true,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  student.obtainedMarks = double.tryParse(value);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              color: const Color(0xFF1F1F1F),
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _saveGrades,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  'Save Grades',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateAllSelectedState() {
    bool allSelected = true;
    for (var student in students) {
      if (student.isSelected == null || student.isSelected == false) {
        allSelected = false;
        break;
      }
    }
    setState(() {
      _areAllStudentsSelected = allSelected;
    });
  }
} 