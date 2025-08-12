import 'package:flutter/material.dart';

import '../../../../shared/domain/entities/Student.dart';
import 'StudentDashboardPage.dart';

class StudentInfoPage extends StatelessWidget {
  final Student student = StudentDashboardPage.studentProfile!;

  StudentInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(bottom: 16),
              centerTitle: true,
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Student Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    student.studentRollNo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      const Color(0xFF1B7660)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Student Avatar Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.1),
                            const Color(0xFF1B7660).withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              student.studentName[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student.studentName,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Ubuntu',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  student.studentRollNo,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Ubuntu',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${student.studentDepartment} - ${student.studentSemester}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontFamily: 'Ubuntu',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Personal Information Card
                  _buildInfoCard(
                    context,
                    'Personal Information',
                    [
                      _buildDetailRow(
                          Icons.person, 'Full Name', student.studentName),
                      _buildDetailRow(Icons.family_restroom, 'Father\'s Name',
                          student.fatherName),
                      _buildDetailRow(
                          Icons.credit_card, 'CNIC', student.studentCNIC),
                      _buildDetailRow(Icons.phone, 'Contact Number',
                          student.studentContactNo),
                      _buildDetailRow(
                          Icons.email, 'Email', student.studentEmail),
                      _buildDetailRow(
                          Icons.location_on, 'Address', student.studentAddress),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Academic Information Card
                  _buildInfoCard(
                    context,
                    'Academic Information',
                    [
                      _buildDetailRow(Icons.school, 'Department',
                          student.studentDepartment),
                      _buildDetailRow(
                          Icons.class_, 'Semester', student.studentSemester),
                      _buildDetailRow(
                          Icons.group, 'Section', student.studentSection),
                      _buildDetailRow(
                          Icons.grade, 'CGPA', student.studentCGPA.toString()),
                      _buildDetailRow(Icons.calendar_today, 'Academic Year',
                          student.studentAcademicYear),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Additional Information Card
                  _buildInfoCard(
                    context,
                    'Additional Information',
                    [
                      _buildDetailRow(Icons.person_outline, 'Gender',
                          student.studentGender),
                      _buildDetailRow(
                          Icons.access_time, 'Shift', student.studentShift),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, String title, List<Widget> children) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getIconForTitle(title),
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Ubuntu',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                    fontFamily: 'Ubuntu',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Ubuntu',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'Personal Information':
        return Icons.person;
      case 'Academic Information':
        return Icons.school;
      case 'Additional Information':
        return Icons.info;
      default:
        return Icons.info;
    }
  }
}
