import 'package:flutter/material.dart';
import 'StudentGradingPage.dart';
import '../../domain/entities/Assignment.dart';

class CourseAssignmentsPage extends StatefulWidget {
  final String courseId;
  final String courseCode;
  final String sectionClass;

  const CourseAssignmentsPage({
    super.key,
    required this.courseId,
    required this.courseCode,
    required this.sectionClass,
  });

  @override
  State<CourseAssignmentsPage> createState() => _CourseAssignmentsPageState();
}

class _CourseAssignmentsPageState extends State<CourseAssignmentsPage> {
  late List<Assignment> assignments;

  @override
  void initState() {
    super.initState();
    // Initialize with sample data
    assignments = [
      Assignment(
        id: '1',
        courseId: widget.courseId,
        title: 'Final Project',
        type: 'Assignment',
        totalMarks: 100,
        date: 'Aug 12, 2024',
        edited: 'Aug 12, 2024',
        semester: 'Fall 2024',
        isPublished: true,
        dueDate: 'Aug 30, 2024',
      ),
    ];
  }

  void _addNewAssignment() {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController();
        final marksController = TextEditingController();
        String selectedType = 'Assignment';

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF2D2D2D),
              title: const Text(
                'Create New Assignment/Quiz',
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      dropdownColor: const Color(0xFF3D3D3D),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Type',
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Assignment',
                          child: Text('Assignment'),
                        ),
                        DropdownMenuItem(
                          value: 'Quiz',
                          child: Text('Quiz'),
                        ),
                        DropdownMenuItem(
                          value: 'Presentation',
                          child: Text('Presentation'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedType = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: marksController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Total Marks',
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        marksController.text.isNotEmpty) {
                      final newAssignment = Assignment.create(
                        courseId: widget.courseId,
                        title: titleController.text,
                        type: selectedType,
                        totalMarks: double.tryParse(marksController.text) ?? 0,
                      );
                      
                      setState(() {
                        this.setState(() {
                          assignments.insert(0, newAssignment);
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _editAssignment(int index) {
    final assignment = assignments[index];
    final titleController = TextEditingController(text: assignment.title);
    final marksController = TextEditingController(text: assignment.totalMarks.toString());
    String selectedType = assignment.type;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF2D2D2D),
              title: const Text(
                'Edit Assignment/Quiz',
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      dropdownColor: const Color(0xFF3D3D3D),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Type',
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Assignment',
                          child: Text('Assignment'),
                        ),
                        DropdownMenuItem(
                          value: 'Quiz',
                          child: Text('Quiz'),
                        ),
                        DropdownMenuItem(
                          value: 'Presentation',
                          child: Text('Presentation'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedType = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: marksController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Total Marks',
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        marksController.text.isNotEmpty) {
                      this.setState(() {
                        assignments[index] = assignment.copyWith(
                          title: titleController.text,
                          type: selectedType,
                          totalMarks: double.tryParse(marksController.text) ?? 0,
                          edited: DateTime.now().toString().split(' ')[0],
                        );
                      });
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showOptions(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2D2D2D),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.white),
              title: const Text('Edit', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _editAssignment(index);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(index);
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text(
          'Delete Assignment',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${assignments[index].title}"?',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                assignments.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.courseCode),
            Text(
              widget.sectionClass,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: assignments.isEmpty 
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No assignments or quizzes yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addNewAssignment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Create New'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: assignments.length,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemBuilder: (context, index) {
                final assignment = assignments[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  color: const Color(0xFF2D2D2D),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentGradingPage(
                            assignmentId: assignment.id,
                            title: assignment.title,
                            totalMarks: assignment.totalMarks.toInt(),
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                assignment.type == 'Quiz' 
                                    ? Icons.quiz
                                    : assignment.type == 'Presentation'
                                        ? Icons.slideshow
                                        : Icons.assignment,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      assignment.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Posted ${assignment.date}${assignment.edited != null ? ' (Edited ${assignment.edited})' : ''}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.more_vert, color: Colors.white),
                                onPressed: () => _showOptions(index),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.grey),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Points: ${assignment.totalMarks}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudentGradingPage(
                                        assignmentId: assignment.id,
                                        title: assignment.title,
                                        totalMarks: assignment.totalMarks.toInt(),
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('GRADE'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewAssignment,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
} 