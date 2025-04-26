import 'package:flutter/material.dart';

import '../../../../../../shared/domain/entities/Student.dart'; // Make sure to replace the path accordingly

class StudentDetailPage extends StatelessWidget {
  final Student student;

  const StudentDetailPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailRow('Student ID', student.studentRollNo),
            _buildDetailRow('Name', student.studentName),
            _buildDetailRow('Father\'s Name', student.fatherName),
            _buildDetailRow('CNIC', student.studentCNIC),
            _buildDetailRow('Contact No.', student.studentContactNo),
            _buildDetailRow('Email', student.studentEmail),
            _buildDetailRow('Gender', student.studentGender),
            _buildDetailRow('Address', student.studentAddress),
            _buildDetailRow('Department', student.studentDepartment),
            _buildDetailRow('Semester', student.studentSemester),
            _buildDetailRow('Section', student.studentSection),
            _buildDetailRow('CGPA', student.studentCGPA.toString()),
          ],
        ),
      ),
    );
  }

  // Helper function to build rows with title and value
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
