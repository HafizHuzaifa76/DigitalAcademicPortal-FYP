import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      SnackBar(
        content: const Text('Grades saved successfully'),
        backgroundColor: Get.theme.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int turnedIn = students.where((s) => s.obtainedMarks != null && s.obtainedMarks! > 0).length;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveGrades,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              color: Get.theme.primaryColor.withOpacity(0.1),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Get.theme.primaryColor.withOpacity(0.3)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: PopupMenuButton<String>(
                      color: Colors.white,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${widget.totalMarks} points',
                            style: TextStyle(
                              color: Get.theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, color: Get.theme.primaryColor),
                        ],
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: '${widget.totalMarks}',
                          child: Text(
                            '${widget.totalMarks} points',
                            style: TextStyle(color: Get.theme.primaryColor),
                          ),
                        ),
                        PopupMenuItem(
                          value: '50',
                          child: Text('50 points', style: TextStyle(color: Get.theme.primaryColor)),
                        ),
                        PopupMenuItem(
                          value: '25',
                          child: Text('25 points', style: TextStyle(color: Get.theme.primaryColor)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Get.theme.primaryColor.withOpacity(0.05),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Text(
                    'Instructions',
                    style: TextStyle(color: Get.theme.primaryColor.withOpacity(0.7)),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Student Work',
                        style: TextStyle(color: Get.theme.primaryColor, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 2,
                        width: 100,
                        color: Get.theme.primaryColor,
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
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Get.theme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Turned in',
                    style: TextStyle(color: Get.theme.primaryColorDark),
                  ),
                  const Spacer(),
                  Text(
                    '${students.length}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Get.theme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Assigned',
                    style: TextStyle(color: Get.theme.primaryColorDark),
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
                      style: TextStyle(color: Get.theme.primaryColorDark),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Get.theme.primaryColor),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Divider(color: Get.theme.primaryColor.withOpacity(0.2)),
            ListTile(
              tileColor: Get.theme.primaryColor.withOpacity(0.05),
              leading: Checkbox(
                value: _areAllStudentsSelected,
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return Get.theme.primaryColor;
                  }
                  return Get.theme.primaryColor.withOpacity(0.3);
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
                    backgroundColor: Get.theme.primaryColorDark,
                    child: const Icon(Icons.people, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'All students',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Get.theme.primaryColor),
                  ),
                ],
              ),
            ),
            Container(
              color: Get.theme.primaryColor.withOpacity(0.05),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  const SizedBox(width: 72),
                  Text(
                    'ASSIGNED',
                    style: TextStyle(
                      color: Get.theme.primaryColorDark,
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
                    color: index % 2 == 0 
                      ? Colors.white 
                      : Get.theme.primaryColor.withOpacity(0.03),
                    child: ListTile(
                      dense: true,
                      leading: Checkbox(
                        value: student.isSelected,
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.selected)) {
                            return Get.theme.primaryColor;
                          }
                          return Get.theme.primaryColor.withOpacity(0.3);
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
                            backgroundColor: Get.theme.primaryColorDark,
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
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Get.theme.primaryColor,
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
                              style: TextStyle(color: Get.theme.primaryColor),
                              decoration: InputDecoration(
                                hintText: 'Points',
                                hintStyle: TextStyle(color: Get.theme.primaryColorDark.withOpacity(0.5)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                border: const OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Get.theme.primaryColor.withOpacity(0.3)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Get.theme.primaryColor),
                                ),
                                isDense: true,
                                fillColor: Colors.white,
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
              color: Get.theme.primaryColor.withOpacity(0.05),
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _saveGrades,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.primaryColor,
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