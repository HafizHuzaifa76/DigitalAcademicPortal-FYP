import 'dart:ui';

import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/departments/domain/entities/Semester.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/student/presentation/pages/StudentDetailPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../../../../shared/domain/entities/Student.dart';
import '../controllers/StudentController.dart';

class DepartmentStudentsPage extends StatefulWidget {
  final String deptName;
  final String deptCode;
  List<Semester> semesterList;
  DepartmentStudentsPage(
      {super.key,
      required this.deptName,
      required this.deptCode,
      required this.semesterList});

  @override
  State<DepartmentStudentsPage> createState() => _DepartmentStudentsPageState();
}

class _DepartmentStudentsPageState extends State<DepartmentStudentsPage> {
  final StudentController controller = Get.find();
  final addStudentKey = GlobalKey<FormState>();
  final editStudentKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller.semesterList = widget.semesterList;
    controller.deptName = widget.deptName;
    controller.showDepartmentStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          var currentSemester = controller.semesterList.first;
          if (currentSemester.sectionLimit != 0) {
            if (currentSemester.totalCourses > currentSemester.numOfCourses ||
                currentSemester.totalCourses == 0) {
              Utils().showErrorSnackBar('ERROR',
                  'First Add All Courses of ${currentSemester.semesterName}');
            } else {
              addStudentOptionsBottomSheet(context);
              // addStudentBottomSheet(context);
            }
          } else {
            setSectionLengthBottomSheet(context);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(bottom: 90),
              centerTitle: true,
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Students',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text('Department of ${widget.deptName}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      const Color(0xFF1B7660),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
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
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            onChanged: (query) {
                              controller.filterStudents(query);
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              hintText: 'Search students...',
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: Colors.grey[600],
                                size: 24,
                              ),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animations/loading_animation4.json',
                        width: 120,
                        height: 120,
                        fit: BoxFit.scaleDown,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading students...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontFamily: 'Ubuntu',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              if (controller.filteredStudentList.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.group_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No students available",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Add your first student to get started",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                            fontFamily: 'Ubuntu',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final student = controller.filteredStudentList[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                Get.to(StudentDetailPage(student: student));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.person_rounded,
                                        color: Theme.of(context).primaryColor,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            student.studentRollNo,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontFamily: 'Ubuntu',
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Name: ${student.studentName}\nFather: ${student.fatherName}',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                              fontFamily: 'Ubuntu',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios,
                                        color: Colors.grey, size: 18),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: controller.filteredStudentList.length,
                    ),
                  ),
                );
              }
            }
          }),
        ],
      ),
    );
  }

  Future addStudentBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
          ),
          child: Column(
            children: [
              // Modern handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header with gradient background
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      const Color(0xFF1B7660),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(32.0)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person_add_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Add New Student',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Ubuntu',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Fill in the student details below',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                              fontFamily: 'Ubuntu',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Form content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Scrollbar(
                    thumbVisibility: true,
                    radius: const Radius.circular(30),
                    thickness: 6,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 13.0),
                      child: SingleChildScrollView(
                        child: Form(
                          key: addStudentKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 24),

                              // Student Name Field
                              _buildModernTextField(
                                controller: controller.studentNameController,
                                label: 'Student Name',
                                icon: Icons.person_outline,
                                keyboardType: TextInputType.name,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Student\'s name is required.';
                                  }
                                  return null;
                                },
                              ),

                              // Father's Name Field
                              _buildModernTextField(
                                controller: controller.fatherNameController,
                                label: 'Father\'s Name',
                                icon: Icons.person_outline,
                                keyboardType: TextInputType.name,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Father\'s name is required.';
                                  }
                                  return null;
                                },
                              ),

                              // CNIC Field
                              _buildModernTextField(
                                controller: controller.studentCNICController,
                                label: 'CNIC',
                                icon: Icons.credit_card_outlined,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'CNIC is required.';
                                  }
                                  return null;
                                },
                              ),

                              // Contact Number Field
                              _buildModernTextField(
                                controller:
                                    controller.studentContactNoController,
                                label: 'Contact Number',
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'A valid contact number is required.';
                                  }
                                  return null;
                                },
                              ),

                              // Email Field
                              _buildModernTextField(
                                controller: controller.studentEmailController,
                                label: 'Email',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'A valid email is required.';
                                  }
                                  return null;
                                },
                              ),

                              // Gender Dropdown
                              _buildModernDropdown(
                                value: controller.selectedGender.isEmpty
                                    ? null
                                    : controller.selectedGender,
                                label: 'Gender',
                                icon: Icons.person_outline,
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

                              // Shift Dropdown
                              _buildModernDropdown(
                                value: controller.selectedShift.isEmpty
                                    ? null
                                    : controller.selectedShift,
                                label: 'Shift',
                                icon: Icons.schedule_outlined,
                                items:
                                    ['Morning', 'Evening'].map((String shift) {
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

                              // Academic Year Dropdown
                              _buildModernDropdown(
                                value: controller.selectedYear.isEmpty
                                    ? null
                                    : controller.selectedYear,
                                label: 'Academic Year',
                                icon: Icons.calendar_today_outlined,
                                items: List.generate(4, (index) {
                                  int year = DateTime.now().year - index;
                                  return DropdownMenuItem<String>(
                                    value: year.toString(),
                                    child: Text(year.toString()),
                                  );
                                }),
                                onChanged: (newValue) {
                                  controller.selectedYear = newValue!;
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Academic year is required.';
                                  }
                                  return null;
                                },
                              ),

                              // Address Field
                              _buildModernTextField(
                                controller: controller.studentAddressController,
                                label: 'Address',
                                icon: Icons.location_on_outlined,
                                keyboardType: TextInputType.streetAddress,
                                maxLines: 3,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Address is required.';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Modern save button
              Container(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (addStudentKey.currentState!.validate()) {
                        controller.addStudent('BS${widget.deptCode}');
                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      shadowColor:
                          Theme.of(context).primaryColor.withOpacity(0.3),
                    ),
                    child: const Text(
                      'Save Student',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Ubuntu',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// Helper method for modern text fields
  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    TextCapitalization? textCapitalization,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        maxLines: maxLines ?? 1,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 18,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }

// Helper method for modern dropdowns
  Widget _buildModernDropdown({
    required String? value,
    required String label,
    required IconData icon,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 18,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        items: items,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Future showExcelBottomSheet(BuildContext context, String buttonType,
      String semester, List<String> columns) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                buttonType,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Ubuntu'),
              ),
              const SizedBox(height: 10),

              const Text(
                'Your Excel sheet should contain these columns:',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
              ),
              const SizedBox(height: 10),
              // List the columns
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20.0,
                runSpacing: 10.0,
                children: columns
                    .map((col) => SizedBox(
                          width: (MediaQueryData.fromView(
                                          WidgetsBinding.instance.window)
                                      .size
                                      .width /
                                  3) -
                              30,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(3)),
                            child: Text(
                              col,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Ubuntu'),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Important',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 18,
                    fontFamily: 'Ubuntu'),
              ),
              const Text(
                'Email and CNIC should be unique',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Ubuntu'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (buttonType.contains('Add Previous Students')) {
                    controller
                        .fetchPreviousStudentsFromExcel(semester)
                        .then((futureList) {
                      if (futureList.isNotEmpty) {
                        controller.addStudentList(futureList, false);
                      }
                    });
                  } else if (buttonType.contains('Add New Students')) {
                    controller
                        .fetchNewStudentsFromExcel('BS${widget.deptCode}')
                        .then((futureList) {
                      if (futureList.isNotEmpty) {
                        Get.to(ListWidget(items: futureList));
                      }
                    });
                  }
                },
                child: const Text('Select File',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Ubuntu',
                        fontSize: 18)),
              ),
            ],
          ),
        );
      },
    );
  }

  Future addStudentOptionsBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose an Option',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the bottom sheet
                  addStudentBottomSheet(context);
                },
                child: const Text('Add Student Manually',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Ubuntu',
                        fontSize: 18)),
              ),
              ElevatedButton(
                onPressed: () {
                  showExcelBottomSheet(
                    context,
                    'Add New Students',
                    'SEM-I',
                    [
                      'Name',
                      'Father Name',
                      'CNIC',
                      'Contact No',
                      'Email',
                      'Gender',
                      'Address',
                      'Shift',
                    ],
                  );
                  // Navigator.pop(context);
                },
                child: const Text('Add New Students via Excel File',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Ubuntu',
                        fontSize: 18)),
              ),
              ElevatedButton(
                onPressed: () {
                  semestersBottomSheet(context);
                },
                child: const Text('Add Previous Students via Excel File',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Ubuntu',
                        fontSize: 18)),
              ),
            ],
          ),
        );
      },
    );
  }

  void semestersBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7.5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: controller.semesterList
                  .sublist(1)
                  .map((semester) => Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (semester.totalCourses > semester.numOfCourses ||
                                semester.totalCourses == 0) {
                              Utils().showErrorSnackBar('ERROR',
                                  'First Add All Courses of ${semester.semesterName}');
                            } else {
                              showExcelBottomSheet(
                                context,
                                'Add Previous Students',
                                semester.semesterName,
                                [
                                  'Roll No',
                                  'Name',
                                  'Father Name',
                                  'CNIC',
                                  'Contact No',
                                  'Email',
                                  'Gender',
                                  'Address',
                                  'Shift',
                                  'Section',
                                  'CGPA',
                                ],
                              );
                            }
                          },
                          child: Text(
                            semester.semesterName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Ubuntu'),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          );
        });
  }

  Future setSectionLengthBottomSheet(BuildContext context) {
    int selectedLimited = 50;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Section Limit',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                'Please set the maximum limit for students in this class section',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: SizedBox(
                  height: 130,
                  width: 190,
                  child: CupertinoPicker(
                    itemExtent: 30,
                    onSelectedItemChanged: (int value) {
                      selectedLimited = value;
                    },
                    scrollController: FixedExtentScrollController(
                      initialItem: 29,
                    ),
                    children: List.generate(
                      60,
                      (index) => Text(
                        "${index + 21} Students",
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Ubuntu',
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 'Set' button
              ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).primaryColor,
                  ),
                  fixedSize:
                      const WidgetStatePropertyAll(Size(double.maxFinite, 45)),
                ),
                onPressed: () {
                  controller.setSectionLimit('SEM-I', selectedLimited + 21);
                },
                child: const Text(
                  'Set Limit',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

class _SliverSearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverSearchBarDelegate({required this.child});

  @override
  double get minExtent => 70.0;

  @override
  double get maxExtent => 70.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class ListWidget extends StatelessWidget {
  final List<Student> items;
  final StudentController controller = Get.find();

  ListWidget({required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.addStudentList(items, true);
        },
        child: Icon(Icons.done_outline, size: 30, color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                '${items[index].studentName}, ${items[index].studentCNIC}, ${items[index].studentRollNo}, '),
            subtitle: Text(
                '${items[index].studentEmail}, ${items[index].studentContactNo}, ${items[index].studentShift}, ${items[index].studentAcademicYear}, '),
          );
        },
      ),
    );
  }
}
