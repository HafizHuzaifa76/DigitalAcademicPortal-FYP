import 'package:digital_academic_portal/features/admin/shared/student/presentation/pages/StudentDetailPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../domain/entities/Student.dart';
import '../controllers/StudentController.dart';

class DepartmentStudentsPage extends StatefulWidget {
  final String deptName;
  final String deptCode;
  int sectionLength;
  DepartmentStudentsPage({super.key, required this.deptName, required this.sectionLength, required this.deptCode});

  @override
  State<DepartmentStudentsPage> createState() => _DepartmentStudentsPageState();
}

class _DepartmentStudentsPageState extends State<DepartmentStudentsPage> {
  final StudentController controller = Get.find();
  final addStudentKey = GlobalKey<FormState>();
  final editStudentKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller.showDepartmentStudents(widget.deptName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
              onPressed: () {
                if (widget.sectionLength != 0) {
                  addStudentDialog(context);
                } else {
                  setSectionLengthDialog();
                }
              },
              icon: const Icon(Icons.add)
          )
        ],
      ),
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Lottie.asset(
              'assets/animations/loading_animation4.json',
              width: 100,
              height: 100,
              fit: BoxFit.scaleDown,
            );
          }
          else {
            if (controller.studentList.isEmpty) {
              return const Center(child: Text("No Students available"));
            } else {
              return ListView.builder(
                itemCount: controller.studentList.length,
                itemBuilder: (context, index) {
                  final student = controller.studentList[index];
                  return ListTile(
                    title: Text(student.studentRollNo),
                    subtitle: Text(
                        'name: ${student.studentName}, father: ${student.fatherName}'),
                    onTap: () {
                      Get.to(StudentDetailPage(student: student));
                    },
                  );
                },
              );
            }
          }
        }),
      ),
    );
  }

  Future setSectionLengthDialog() {
    int selectedLimited = 50;
    return Get.defaultDialog(
      title: 'Section Limit',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Ubuntu'),

      content: Column(
        children: [
          const Text('You have to set section limit first', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, fontFamily: 'Ubuntu')),
          const SizedBox(height: 5),

          SizedBox(
              height: 130,
              width: 190,
              child: CupertinoPicker(
                itemExtent: 30,
                onSelectedItemChanged: (int value) {
                  selectedLimited = value;
                },
                scrollController: FixedExtentScrollController(
                    initialItem: 30
                ),
                children: List.generate(
                  60,
                      (index) => Text("${index+21} Students", style: const TextStyle(color: Colors.black, fontFamily: 'Font1', fontSize: 25, fontWeight: FontWeight.w500)),
                ),
              )
          ),
        ],
      ),
      confirm: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor)
        ),
        onPressed: () {
          controller.setSectionLimit(widget.deptName, 'SEM-I', selectedLimited + 21).then((value){
            widget.sectionLength = selectedLimited;
          });
        },
          child: const Text('Set', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18, fontFamily: 'Ubuntu'))
      ),
    );
  }

  Future addStudentDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Student'),
          content: SingleChildScrollView(
            child: Form(
              key: addStudentKey, // Assuming you have defined a GlobalKey<FormState>
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: controller.studentNameController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
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
                  TextFormField(
                    controller: controller.fatherNameController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
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
                  TextFormField(
                    controller: controller.studentCNICController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'CNIC',
                      hintText: 'Enter the student\'s CNIC number (without dashes)',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'CNIC is required.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: controller.studentContactNoController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Contact Number',
                      hintText: 'Enter a valid phone number (e.g., 03XX-XXXXXXX)',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'A valid contact number is required.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: controller.studentEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter the student\'s email address',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'A valid email is required.';
                      }
                      return null;
                    },
                  ),

                  // Dropdown for Gender
                  DropdownButtonFormField<String>(
                    value: controller.selectedGender.isEmpty ? null : controller.selectedGender,
                    decoration: const InputDecoration(
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

                  // Dropdown for Shift
                  DropdownButtonFormField<String>(
                    value: controller.selectedShift.isEmpty ? null : controller.selectedShift,
                    decoration: const InputDecoration(
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

                  // Dropdown for Academic Year with dynamic last 4 years
                  DropdownButtonFormField<String>(
                    value: controller.selectedShift.isEmpty ? null : controller.selectedYear,
                    decoration: const InputDecoration(
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

                  TextFormField(
                    controller: controller.studentAddressController,
                    keyboardType: TextInputType.streetAddress,
                    decoration: const InputDecoration(
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
          actions: [
            ElevatedButton(
              onPressed: () {
                if (addStudentKey.currentState!.validate()) {
                  controller.addStudent(widget.deptName, widget.deptCode);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );

      },
    );
  }

  Future editStudentDialog(BuildContext context, Student student) {
    controller.setControllerValues(student);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Student'),
          content: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              child: Form(
                key: addStudentKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: controller.studentNameController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
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
                    TextFormField(
                      controller: controller.fatherNameController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
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
                    TextFormField(
                      controller: controller.studentCNICController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'CNIC',
                        hintText: 'Enter the student\'s CNIC number (without dashes)',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'CNIC is required.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: controller.studentContactNoController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Contact Number',
                        hintText: 'Enter a valid phone number (e.g., 03XX-XXXXXXX)',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'A valid contact number is required.';
                        }
                        return null;
                      },
                    ),

                    // Dropdown for Gender
                    DropdownButtonFormField<String>(
                      value: controller.selectedGender,
                      decoration: const InputDecoration(
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

                    // Dropdown for Shift
                    DropdownButtonFormField<String>(
                      value: controller.selectedShift,
                      decoration: const InputDecoration(
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

                    // Dropdown for Academic Year with dynamic last 4 years
                    DropdownButtonFormField<String>(
                      value: controller.selectedYear,
                      decoration: const InputDecoration(
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

                    TextFormField(
                      controller: controller.studentAddressController,
                      keyboardType: TextInputType.streetAddress,
                      decoration: const InputDecoration(
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
          actions: [
            ElevatedButton(
              onPressed: () {
                if (addStudentKey.currentState!.validate()) {
                  var newStudent = Student(
                    studentRollNo: student.studentRollNo,
                    studentName: controller.studentNameController.text,
                    fatherName: controller.fatherNameController.text,
                    studentCNIC: controller.studentCNICController.text,
                    studentContactNo: controller.studentContactNoController.text,
                    studentEmail: student.studentEmail, // Keeping original email
                    studentGender: controller.selectedGender, // Updated gender field
                    studentShift: controller.selectedShift, // Updated shift field
                    studentAcademicYear: controller.selectedYear, // Updated academic year field
                    studentAddress: controller.studentAddressController.text,
                    studentDepartment: student.studentDepartment,
                    studentSemester: student.studentSemester,
                    studentSection: student.studentSection,
                    studentCGPA: student.studentCGPA,
                  );
                  controller.editStudent(newStudent);
                  Navigator.pop(context); // Close the dialog after saving
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }


}
