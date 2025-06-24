import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'StudentGradingPage.dart';
import '../../domain/entities/Grade.dart';
import '../controllers/TeacherGradeController.dart';
import '../pages/FinalResultsPage.dart';

class CourseGradesPage extends StatefulWidget {
  final String courseId;
  final String courseCode;
  final String sectionClass;

  const CourseGradesPage({
    super.key,
    required this.courseId,
    required this.courseCode,
    required this.sectionClass,
  });

  @override
  State<CourseGradesPage> createState() => _CourseGradesPageState();
}

class _CourseGradesPageState extends State<CourseGradesPage> {
  final TeacherGradeController controller = Get.find();
  final TextEditingController _deleteConfirmController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.loadGrades(widget.courseId);
  }

  @override
  void dispose() {
    _deleteConfirmController.dispose();
    super.dispose();
  }

  void _addNewGrade() {
    bool hasMid = controller.gradesList.any((grade) => grade.type == 'Mid');
    bool hasFinal = controller.gradesList.any((grade) => grade.type == 'Final');

    showDialog(
      context: context,
      builder: (context) {
        final marksController = TextEditingController();
        bool isLoading = false;

        // Count existing assignments by type
        int assignmentCount =
            controller.gradesList.where((a) => a.type == 'Assignment').length;
        int quizCount =
            controller.gradesList.where((a) => a.type == 'Quiz').length;
        int presentationCount =
            controller.gradesList.where((a) => a.type == 'Presentation').length;

        String selectedType = 'Assignment';
        String title = 'A${assignmentCount + 1}';

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('New Grade',
                  style: TextStyle(color: Get.theme.primaryColor)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: InputDecoration(
                      labelText: 'Type',
                      labelStyle: TextStyle(
                          color: Get.theme.primaryColor.withOpacity(0.7)),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Get.theme.primaryColor.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Get.theme.primaryColor),
                      ),
                    ),
                    items: [
                      'Assignment',
                      'Quiz',
                      'Presentation',
                      if (!hasMid) 'Mid',
                      if (!hasFinal) 'Final'
                    ]
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type,
                                  style:
                                      TextStyle(color: Get.theme.primaryColor)),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedType = value;
                          // Update title based on type
                          if (value == 'Assignment') {
                            title = 'A${assignmentCount + 1}';
                          } else if (value == 'Quiz') {
                            title = 'Q${quizCount + 1}';
                          } else if (value == 'Presentation') {
                            title = 'P${presentationCount + 1}';
                          } else {
                            title = value; // For Mid and Final
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: TextEditingController(text: title),
                    readOnly: true,
                    style: TextStyle(color: Get.theme.primaryColor),
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(
                          color: Get.theme.primaryColor.withOpacity(0.7)),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Get.theme.primaryColor.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Get.theme.primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: marksController,
                    style: TextStyle(color: Get.theme.primaryColor),
                    decoration: InputDecoration(
                      labelText: 'Total Marks',
                      labelStyle: TextStyle(
                          color: Get.theme.primaryColor.withOpacity(0.7)),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Get.theme.primaryColor.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Get.theme.primaryColor),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: Text('Cancel',
                      style: TextStyle(color: Get.theme.primaryColor)),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (marksController.text.isNotEmpty) {
                            setState(() => isLoading = true);
                            final grade = Grade(
                              id: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              title: title,
                              type: selectedType,
                              totalMarks:
                                  int.tryParse(marksController.text) ?? 0,
                            );
                            await controller
                                .createGrades(grade)
                                .then((gradeWithMarks) => {
                                      if (gradeWithMarks != null)
                                        {
                                          Get.off(() => StudentGradingPage(
                                              grade: gradeWithMarks))
                                        }
                                      else
                                        {print('null grade')}
                                    });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Get.theme.primaryColor,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Create',
                          style: TextStyle(color: Colors.white)),
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
      backgroundColor: Colors.white,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: Get.theme.primaryColor),
              title:
                  Text('Edit', style: TextStyle(color: Get.theme.primaryColor)),
              onTap: () {
                Navigator.pop(context);
                _showEditDialog(index);
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

  void _showEditDialog(int index) {
    final grade = controller.gradesList[index];
    final marksController =
        TextEditingController(text: grade.totalMarks.toString());
    bool isLoading = false;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Grade',
                  style: TextStyle(color: Get.theme.primaryColor)),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: TextEditingController(text: grade.title),
                      readOnly: true,
                      style: TextStyle(color: Get.theme.primaryColor),
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(
                            color: Get.theme.primaryColor.withOpacity(0.7)),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: TextEditingController(text: grade.type),
                      readOnly: true,
                      style: TextStyle(color: Get.theme.primaryColor),
                      decoration: InputDecoration(
                        labelText: 'Type',
                        labelStyle: TextStyle(
                            color: Get.theme.primaryColor.withOpacity(0.7)),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: marksController,
                      style: TextStyle(color: Get.theme.primaryColor),
                      decoration: InputDecoration(
                        labelText: 'Total Marks',
                        labelStyle: TextStyle(
                            color: Get.theme.primaryColor.withOpacity(0.7)),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Get.theme.primaryColor.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Get.theme.primaryColor),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter total marks';
                        }

                        final newTotalMarks = int.tryParse(value);
                        if (newTotalMarks == null) {
                          return 'Please enter a valid number';
                        }

                        // Find the highest marks any student has obtained
                        double highestStudentMarks = 0.0;
                        for (var studentMarks in grade.obtainedMarks.values) {
                          final marks =
                              double.tryParse(studentMarks.toString()) ?? 0.0;
                          if (marks > highestStudentMarks) {
                            highestStudentMarks = marks;
                          }
                        }

                        // Check if new total marks is less than highest student marks
                        if (newTotalMarks < highestStudentMarks) {
                          return 'Cannot reduce marks below ${highestStudentMarks.toStringAsFixed(1)}. '
                              'A student already has ${highestStudentMarks.toStringAsFixed(1)} marks.';
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: Text('Cancel',
                      style: TextStyle(color: Get.theme.primaryColor)),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          // Validate the form
                          if (formKey.currentState?.validate() ?? false) {
                            setState(() => isLoading = true);
                            final updatedGrade = grade.copyWith(
                              totalMarks:
                                  int.tryParse(marksController.text) ?? 0,
                            );
                            await controller.updateGrade(updatedGrade);
                            if (mounted) {
                              Navigator.pop(context);
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Get.theme.primaryColor,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Save',
                          style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(int index) {
    _deleteConfirmController.clear();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Delete Grade',
                style: TextStyle(color: Get.theme.primaryColor),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Are you sure you want to delete "${controller.gradesList[index].title}"?',
                    style: TextStyle(color: Get.theme.primaryColor),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _deleteConfirmController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: 'Type DELETE to confirm',
                      labelStyle: TextStyle(
                          color: Get.theme.primaryColor.withOpacity(0.7)),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Get.theme.primaryColor.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Get.theme.primaryColor),
                      ),
                      errorText: _deleteConfirmController.text.isNotEmpty &&
                              _deleteConfirmController.text != 'DELETE'
                          ? 'Please type DELETE exactly'
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {}); // Trigger rebuild to show error
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: Text('Cancel',
                      style: TextStyle(color: Get.theme.primaryColor)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!isLoading &&
                        _deleteConfirmController.text == 'DELETE') {
                      print(_deleteConfirmController.text);
                      setState(() => isLoading = true);
                      await controller
                          .deleteGrade(controller.gradesList[index]);
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                        )
                      : const Text('Delete',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSubmitConfirmation() {
    // Get unique grades with their titles
    final grades = controller.gradesList.toList();

    // Initialize weightage map with default values
    final Map<String, double> weightages = {};

    // Set fixed weightages for Final and Mid
    for (var grade in grades) {
      if (grade.type == 'Final') {
        weightages[grade.title] = 50.0;
      } else if (grade.type == 'Mid') {
        weightages[grade.title] = 20.0;
      } else {
        weightages[grade.title] = 0.0;
      }
    }

    // Calculate remaining weightage
    double remainingWeightage = 30.0;
    int adjustableGrades =
        grades.where((g) => g.type != 'Final' && g.type != 'Mid').length;

    if (adjustableGrades > 0) {
      double defaultWeightage = remainingWeightage / adjustableGrades;
      for (var grade in grades) {
        if (grade.type != 'Final' && grade.type != 'Mid') {
          weightages[grade.title] = defaultWeightage;
        }
      }
    }

    // Create a controller for the total
    final totalController =
        RxDouble(weightages.values.fold(0.0, (sum, value) => sum + value));

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Configure Grade Weightage',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Get.theme.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Set weightage for each grade (Total must be 100%)',
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 8),
              ...grades.map((grade) {
                final isFixed = grade.type == 'Final' || grade.type == 'Mid';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              grade.title,
                              style: TextStyle(
                                color: Get.theme.primaryColor,
                                fontWeight: isFixed
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            Text(
                              grade.type,
                              style: TextStyle(
                                color: Get.theme.primaryColor.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          enabled: !isFixed,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                            suffixText: '%',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                          controller: TextEditingController(
                            text: weightages[grade.title]?.toStringAsFixed(1) ??
                                '0.0',
                          ),
                          onChanged: (value) {
                            if (!isFixed) {
                              final newValue = double.tryParse(value) ?? 0.0;
                              weightages[grade.title] = newValue;
                              _adjustWeightages(weightages, grade.title);
                              totalController.value = weightages.values
                                  .fold(0.0, (sum, value) => sum + value);

                              print('totalController');
                              print(totalController.value);
                              print(weightages);
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              Obx(() {
                final total = totalController.value;
                print('total');
                print(total);
                return Text(
                  'Total: ${total.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: total == 100.0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                );
              }),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final total = totalController.value;
                  if (total != 100.0) {
                    Get.snackbar(
                      'Error',
                      'Total weightage must be 100%',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  Get.back();
                  _calculateAndShowResults(weightages);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.primaryColor,
                ),
                child: const Text(
                  'Calculate Results',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _adjustWeightages(Map<String, double> weightages, String changedTitle) {
    // Find the grade type for the changed title
    final changedGrade =
        controller.gradesList.firstWhere((g) => g.title == changedTitle);
    if (changedGrade.type == 'Final' || changedGrade.type == 'Mid') return;

    // Get all adjustable grades (excluding Final and Mid)
    final adjustableGrades = weightages.entries
        .where((e) =>
            controller.gradesList.firstWhere((g) => g.title == e.key).type !=
                'Final' &&
            controller.gradesList.firstWhere((g) => g.title == e.key).type !=
                'Mid')
        .toList();

    if (adjustableGrades.isEmpty) return;

    // Calculate fixed total (Final + Mid)
    final fixedTotal = weightages.entries
        .where((e) =>
            controller.gradesList.firstWhere((g) => g.title == e.key).type ==
                'Final' ||
            controller.gradesList.firstWhere((g) => g.title == e.key).type ==
                'Mid')
        .fold(0.0, (sum, e) => sum + e.value);

    // Calculate current total
    final total = weightages.values.fold(0.0, (sum, value) => sum + value);
    if (total == 100.0) return;

    // Calculate remaining weightage for adjustable grades
    final remainingWeightage = 100.0 - fixedTotal;

    if (total > 100.0) {
      // If total exceeds 100%, reduce other adjustable grades proportionally
      final excess = total - 100.0;
      final otherGrades =
          adjustableGrades.where((e) => e.key != changedTitle).toList();

      if (otherGrades.isEmpty) {
        // If this is the only adjustable grade, set it to remaining weightage
        weightages[changedTitle] = remainingWeightage;
      } else {
        // Calculate total of other grades
        final otherTotal = otherGrades.fold(0.0, (sum, e) => sum + e.value);

        // Adjust other grades proportionally
        for (var grade in otherGrades) {
          final proportion = grade.value / otherTotal;
          weightages[grade.key] = grade.value - (excess * proportion);
        }
      }
    } else {
      // If total is less than 100%, increase other adjustable grades proportionally
      final deficit = 100.0 - total;
      final otherGrades =
          adjustableGrades.where((e) => e.key != changedTitle).toList();

      if (otherGrades.isEmpty) {
        // If this is the only adjustable grade, set it to remaining weightage
        weightages[changedTitle] = remainingWeightage;
      } else {
        // Calculate total of other grades
        final otherTotal = otherGrades.fold(0.0, (sum, e) => sum + e.value);

        // Adjust other grades proportionally
        for (var grade in otherGrades) {
          final proportion = grade.value / otherTotal;
          weightages[grade.key] = grade.value + (deficit * proportion);
        }
      }
    }

    // Ensure no negative values
    for (var entry in weightages.entries) {
      if (entry.value < 0) {
        weightages[entry.key] = 0.0;
      }
    }

    // Ensure total is exactly 100%
    final finalTotal = weightages.values.fold(0.0, (sum, value) => sum + value);
    if (finalTotal != 100.0) {
      final diff = 100.0 - finalTotal;
      weightages[changedTitle] = (weightages[changedTitle] ?? 0) + diff;
    }
  }

  void _calculateAndShowResults(Map<String, double> weightages) {
    // Calculate total marks for each student
    final studentTotals = <String, double>{};
    final studentMaxMarks = <String, double>{};
    final studentGradeMarks = <String, Map<String, double>>{};

    // Get all student IDs from the grades
    final studentIds = <String>{};
    for (var grade in controller.gradesList) {
      studentIds.addAll(grade.obtainedMarks.keys);
    }

    for (var studentId in studentIds) {
      studentTotals[studentId] = 0.0;
      studentMaxMarks[studentId] = 0.0;
      studentGradeMarks[studentId] = {};

      for (var grade in controller.gradesList) {
        final marks = double.tryParse(
                grade.obtainedMarks[studentId]?.toString() ?? '0') ??
            0.0;
        final maxMarks = grade.totalMarks.toDouble();
        final weightage = weightages[grade.title] ?? 0.0;

        studentGradeMarks[studentId]![grade.title] = marks;
        studentTotals[studentId] =
            studentTotals[studentId]! + (marks * weightage / 100);
        studentMaxMarks[studentId] =
            studentMaxMarks[studentId]! + (maxMarks * weightage / 100);
      }
    }

    // Calculate percentages
    final studentPercentages = <String, double>{};
    for (var studentId in studentIds) {
      final total = studentTotals[studentId]!;
      final maxTotal = studentMaxMarks[studentId]!;
      studentPercentages[studentId] =
          maxTotal > 0 ? (total / maxTotal) * 100 : 0;
    }

    // Navigate to results page
    Get.to(() => FinalResultsPage(
          studentPercentages: studentPercentages,
          studentTotals: studentTotals,
          studentMaxMarks: studentMaxMarks,
          courseCode: widget.courseCode,
          sectionClass: widget.sectionClass,
          weightages: weightages,
          studentGradeMarks: studentGradeMarks,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '${widget.courseCode} - ${widget.sectionClass}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Ubuntu',
          ),
        ),
        backgroundColor: Get.theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.gradesList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 80,
                  color: Get.theme.primaryColor.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No grades available',
                  style: TextStyle(
                    fontSize: 18,
                    color: Get.theme.primaryColor.withOpacity(0.7),
                    fontFamily: 'Ubuntu',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add your first grade to get started',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Ubuntu',
                  ),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            ListView.builder(
              itemCount: controller.gradesList.length,
              padding: const EdgeInsets.only(bottom: 100),
              itemBuilder: (context, index) {
                final grade = controller.gradesList[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Get.to(() => StudentGradingPage(grade: grade));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      Get.theme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  grade.type == 'Quiz'
                                      ? Icons.quiz
                                      : grade.type == 'Presentation'
                                          ? Icons.slideshow
                                          : grade.type == 'Final'
                                              ? Icons.school
                                              : grade.type == 'Mid'
                                                  ? Icons.assignment
                                                  : Icons.assignment,
                                  color: Get.theme.primaryColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      grade.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Get.theme.primaryColor,
                                        fontSize: 16,
                                        fontFamily: 'Ubuntu',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Get.theme.primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        grade.type,
                                        style: TextStyle(
                                          color: Get.theme.primaryColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Ubuntu',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Get.theme.primaryColor,
                                ),
                                onPressed: () => _showOptions(index),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Points',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                      fontFamily: 'Ubuntu',
                                    ),
                                  ),
                                  Text(
                                    '${grade.totalMarks}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Get.theme.primaryColor,
                                      fontSize: 18,
                                      fontFamily: 'Ubuntu',
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Get.to(
                                      () => StudentGradingPage(grade: grade));
                                },
                                icon: const Icon(
                                  Icons.grade,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'GRADE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Ubuntu',
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Get.theme.primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  fixedSize: const Size(120, 40),
                                ),
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
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 80, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Obx(() {
                  final hasMid =
                      controller.gradesList.any((grade) => grade.type == 'Mid');
                  final hasFinal = controller.gradesList
                      .any((grade) => grade.type == 'Final');
                  final hasOtherGrades = controller.gradesList.any(
                      (grade) => grade.type != 'Mid' && grade.type != 'Final');

                  return ElevatedButton.icon(
                    onPressed: () {
                      if (!hasMid || !hasFinal) {
                        Get.snackbar(
                          'Error',
                          'Cannot submit results. Mid and Final grades are required.',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      if (!hasOtherGrades) {
                        Get.snackbar(
                          'Error',
                          'Cannot submit results. At least one additional grade (Assignment/Quiz/Presentation) is required.',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      _showSubmitConfirmation();
                    },
                    icon: const Icon(Icons.check_circle_outline, size: 24),
                    label: const Text(
                      'Submit Final Results',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Ubuntu',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Get.theme.primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewGrade,
        backgroundColor: Get.theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
