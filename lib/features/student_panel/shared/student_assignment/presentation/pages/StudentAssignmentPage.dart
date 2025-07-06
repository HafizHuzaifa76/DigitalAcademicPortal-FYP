import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../controllers/StudentAssignmentController.dart';
import '../../domain/entities/StudentAssignment.dart';
import '../../../student_courses/domain/entities/StudentCourse.dart';

class StudentAssignmentPage extends StatelessWidget {
  const StudentAssignmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentAssignmentController>();

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Modern SliverAppBar with gradient
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Assignments',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2C5D3B),
                      Color(0xFF4A7C59),
                      Color(0xFF6B9B7A),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      left: -30,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                                controller.selectedCourse.value?.courseName ??
                                    'Select Course',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          SizedBox(height: 8),
                          Text(
                            'Manage your course assignments',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.white),
                onPressed: () => controller.fetchAssignments(),
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course Selection Dropdown
                  Obx(() {
                    if (controller.studentCourses.isEmpty) {
                      return Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.school, color: Colors.grey[600]),
                            SizedBox(width: 12),
                            Text(
                              'Loading courses...',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Color(0xFF2C5D3B).withOpacity(0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<StudentCourse>(
                          value: controller.selectedCourse.value,
                          hint: Text('Select Course'),
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down,
                              color: Color(0xFF2C5D3B)),
                          onChanged: (StudentCourse? newValue) {
                            if (newValue != null) {
                              controller.updateSelectedCourse(newValue);
                            }
                          },
                          items: controller.studentCourses
                              .map((StudentCourse course) {
                            return DropdownMenuItem<StudentCourse>(
                              value: course,
                              child: Text(
                                course.courseName,
                                style: TextStyle(
                                  color: Color(0xFF2C5D3B),
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }),

                  SizedBox(height: 24),

                  // Stats Card
                  Obx(() {
                    if (controller.selectedCourse.value == null) {
                      return Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF2C5D3B), Color(0xFF4A7C59)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem('Pending', '0', Icons.pending),
                            _buildStatItem(
                                'Submitted', '0', Icons.check_circle),
                            _buildStatItem('Total', '0', Icons.assignment),
                          ],
                        ),
                      );
                    }

                    final assignments = controller.assignments;
                    final pendingCount = assignments
                        .where((a) => a.status == 'Not Uploaded')
                        .length;
                    final submittedCount = assignments
                        .where((a) => a.status == 'Submitted')
                        .length;

                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF2C5D3B), Color(0xFF4A7C59)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem('Pending', pendingCount.toString(),
                              Icons.pending),
                          _buildStatItem('Submitted', submittedCount.toString(),
                              Icons.check_circle),
                          _buildStatItem('Total', assignments.length.toString(),
                              Icons.assignment),
                        ],
                      ),
                    );
                  }),

                  SizedBox(height: 30),

                  // Assignments List
                  Obx(() {
                    if (controller.selectedCourse.value == null) {
                      return Container(
                        padding: EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Select a course to view assignments',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Course Assignments',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C5D3B),
                          ),
                        ),
                        SizedBox(height: 20),
                        if (controller.isLoading.value)
                          Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF2C5D3B)),
                            ),
                          )
                        else if (controller.error.value.isNotEmpty)
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.red.withOpacity(0.3)),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.error_outline,
                                    color: Colors.red, size: 48),
                                SizedBox(height: 12),
                                Text(
                                  'Error loading assignments',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  controller.error.value,
                                  style: TextStyle(color: Colors.red[700]),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () =>
                                      controller.fetchAssignments(),
                                  child: Text('Retry'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else if (controller.assignments.isEmpty)
                          Container(
                            padding: EdgeInsets.all(40),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.assignment_outlined,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No assignments available',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Check back later for new assignments',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: controller.assignments.length,
                            itemBuilder: (context, index) {
                              final assignment = controller.assignments[index];
                              return _buildAssignmentCard(
                                  assignment, controller);
                            },
                          ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildAssignmentCard(
      StudentAssignment assignment, StudentAssignmentController controller) {
    final isOverdue = DateTime.now().isAfter(assignment.dueDate);
    final statusColor = _getStatusColor(assignment.status);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and status
            Row(
              children: [
                Expanded(
                  child: Text(
                    assignment.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C5D3B),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    assignment.status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Description
            Text(
              assignment.description,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                height: 1.4,
              ),
            ),

            SizedBox(height: 16),

            // Due date with warning if overdue
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: isOverdue ? Colors.red : Colors.grey[600],
                ),
                SizedBox(width: 8),
                Text(
                  'Due: ${_formatDate(assignment.dueDate)}',
                  style: TextStyle(
                    color: isOverdue ? Colors.red : Colors.grey[600],
                    fontSize: 14,
                    fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (isOverdue) ...[
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'OVERDUE',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            SizedBox(height: 20),

            // Action buttons
            Row(
              children: [
                if (assignment.fileUrl.isNotEmpty) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _downloadAssignment(assignment.fileUrl),
                      icon: Icon(Icons.download, size: 18),
                      label: Text('Download'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF2C5D3B),
                        side: BorderSide(color: Color(0xFF2C5D3B)),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                ],
                if (assignment.status == 'Not Uploaded' && !isOverdue) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          _uploadAssignment(assignment, controller),
                      icon: Icon(Icons.upload_file, size: 18),
                      label: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2C5D3B),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ] else if (assignment.status == 'Submitted') ...[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Colors.green.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Submitted',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Not Uploaded':
        return Colors.orange;
      case 'Submitted':
        return Colors.green;
      case 'Uploaded':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _downloadAssignment(String fileUrl) {
    // TODO: Implement file download functionality
    Get.snackbar(
      'Download',
      'Downloading assignment file...',
      backgroundColor: Color(0xFF2C5D3B),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _uploadAssignment(StudentAssignment assignment,
      StudentAssignmentController controller) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );

      if (result != null) {
        // TODO: Upload file to cloud storage and get URL
        String fileUrl = 'https://example.com/uploaded-file.pdf'; // Placeholder

        await controller.submitAssignment(assignment.id, fileUrl);

        Get.snackbar(
          'Success',
          'Assignment submitted successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit assignment: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
