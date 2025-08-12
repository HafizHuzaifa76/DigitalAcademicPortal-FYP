import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../shared/domain/entities/Student.dart';
import '../controllers/StudentController.dart'; // Make sure to replace the path accordingly

class StudentDetailPage extends StatelessWidget {
  final Student student;

  StudentDetailPage({super.key, required this.student});

  final StudentController controller = Get.find();
  final addStudentKey = GlobalKey<FormState>();
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
                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(Get.size.width * 0.35, 50)),
                          onPressed: () {
                            editStudentBottomSheet(context, student);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Edit',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Icon(
                                CupertinoIcons.settings,
                                color: Colors.white,
                              ),
                            ],
                          )),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(Get.size.width * 0.35, 50)),
                          onPressed: () {
                            deleteDialog(student);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Delete',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Icon(
                                CupertinoIcons.delete,
                                color: Colors.white,
                              ),
                            ],
                          )),
                    ],
                  ),
                  const SizedBox(height: 15),

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

  Future deleteDialog(Student student) {
    return Get.dialog(
      AlertDialog(
        title: const Text(
          'Delete Student',
          style: TextStyle(fontFamily: 'Ubuntu'),
        ),
        content: const Text(
          'Are you sure you want to delete?',
          style: TextStyle(fontFamily: 'Ubuntu'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteStudent(student);
              Get.back();
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Ubuntu',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future editStudentBottomSheet(BuildContext context, Student student) {
    controller.setControllerValues(student);
    return showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Ensures the bottom sheet adjusts for the keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom, // Handles soft keyboard
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: addStudentKey, // GlobalKey for validation
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Edit Student',
                            style: TextStyle(
                                fontFamily: 'Ubuntu',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: controller.studentNameController,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              labelText: 'Student Name',
                              hintText: 'Enter the full name of the student',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Student\'s name is required.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: controller.fatherNameController,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              labelText: 'Father\'s Name',
                              hintText: 'Enter the father\'s full name',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Father\'s name is required.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: controller.studentCNICController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              labelText: 'CNIC',
                              hintText:
                                  'Enter the student\'s CNIC number (without dashes)',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'CNIC is required.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: controller.studentContactNoController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              labelText: 'Contact Number',
                              hintText:
                                  'Enter a valid phone number (e.g., 03XX-XXXXXXX)',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'A valid contact number is required.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          // Dropdown for Gender
                          DropdownButtonFormField<String>(
                            value: controller.selectedGender.isEmpty
                                ? null
                                : controller.selectedGender,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              labelText: 'Gender',
                              hintText: 'Select the student\'s gender',
                            ),
                            items: ['Male', 'Female'].map((String gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              controller.selectedGender = newValue!;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Gender is required.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          // Dropdown for Shift
                          DropdownButtonFormField<String>(
                            value: controller.selectedShift.isEmpty
                                ? null
                                : controller.selectedShift,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              labelText: 'Shift',
                              hintText: 'Select the shift (Morning or Evening)',
                            ),
                            items: ['Morning', 'Evening'].map((String shift) {
                              return DropdownMenuItem<String>(
                                value: shift,
                                child: Text(shift),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              controller.selectedShift = newValue!;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Shift selection is required.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          // Dropdown for Academic Year with dynamic last 4 years
                          DropdownButtonFormField<String>(
                            value: controller.selectedYear.isEmpty
                                ? null
                                : controller.selectedYear,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              labelText: 'Academic Year',
                              hintText: 'Select the academic year',
                            ),
                            items: List.generate(4, (index) {
                              int year = DateTime.now().year - index;
                              return DropdownMenuItem<String>(
                                value: year.toString(),
                                child: Text(year.toString()),
                              );
                            }),
                            onChanged: (String? newValue) {
                              controller.selectedYear = newValue!;
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Academic year is required.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: controller.studentAddressController,
                            keyboardType: TextInputType.streetAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              labelText: 'Address',
                              hintText: 'Enter the student\'s home address',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Address is required.';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Save Button
                ElevatedButton(
                  style: const ButtonStyle(
                      fixedSize:
                          WidgetStatePropertyAll(Size(double.maxFinite, 45))),
                  onPressed: () {
                    if (addStudentKey.currentState!.validate()) {
                      var updatedStudent = Student(
                        studentRollNo: student.studentRollNo,
                        studentName: controller.studentNameController.text,
                        fatherName: controller.fatherNameController.text,
                        studentCNIC: controller.studentCNICController.text,
                        studentContactNo:
                            controller.studentContactNoController.text,
                        studentEmail:
                            student.studentEmail, // Keeping original email
                        studentGender:
                            controller.selectedGender, // Updated gender field
                        studentShift:
                            controller.selectedShift, // Updated shift field
                        studentAcademicYear: controller
                            .selectedYear, // Updated academic year field
                        studentAddress:
                            controller.studentAddressController.text,
                        studentDepartment: student.studentDepartment,
                        studentSemester: student.studentSemester,
                        studentSection: student.studentSection,
                        studentCGPA: student.studentCGPA,
                      );
                      controller.editStudent(updatedStudent);
                      Get.back(); // Close bottom sheet after saving
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
