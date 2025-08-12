import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/TeacherController.dart';
import 'TeacherDetailPage.dart';

class SemesterTeacherPage extends StatefulWidget {
  final String deptName;
  final String semester;
  const SemesterTeacherPage({super.key, required this.deptName, required this.semester});

  @override
  State<SemesterTeacherPage> createState() => _SemesterTeacherPageState();
}

class _SemesterTeacherPageState extends State<SemesterTeacherPage> {
  final TeacherController controller = Get.find();
  final addTeacherKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller.showDeptTeachers(widget.deptName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.chevron_right, size: 30),
          fabSize: ExpandableFabSize.regular,
          foregroundColor: Colors.white,
          backgroundColor: Get.theme.primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        closeButtonBuilder: FloatingActionButtonBuilder(
          size: 56,
          builder: (BuildContext context, void Function()? onPressed,
              Animation<double> progress) {
            return IconButton(
              onPressed: onPressed,
              icon: const Icon(
                Icons.check_circle_outline,
                size: 40,
              ),
            );
          },
        ),
        children: [
          IconButton(
            onPressed: () {
              showExcelBottomSheet(context);
            },
            icon: const Icon(FontAwesomeIcons.fileExcel),
          ),
          IconButton(
            onPressed: () {
              addTeacherBottomSheet(context);
            },
            icon: const Icon(CupertinoIcons.add),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8F9FA),
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
                  Text(
                    '${widget.semester} Teachers',
                    style: const TextStyle(
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
                              controller.filterTeachers(query);
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              hintText: 'Search teachers...',
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
                        'assets/animations/loading_animation1.json',
                        width: 100,
                        height: 100,
                        fit: BoxFit.scaleDown,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading teachers...',
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
              if (controller.filteredTeacherList.isEmpty) {
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
                          "No teachers available",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Add your first teacher to get started",
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
                        final teacher = controller.filteredTeacherList[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                Get.to(TeacherDetailPage(teacher: teacher));
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
                                            teacher.teacherName,
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
                                            'CNIC: ${teacher.teacherCNIC}\nEmail: ${teacher.teacherEmail}',
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
                      childCount: controller.filteredTeacherList.length,
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

  Future addTeacherBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ensures that the bottom sheet is full height
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
                Text(
                  'Add Teacher',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    radius: const Radius.circular(30),
                    thickness: 6,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 13.0),
                      child: SingleChildScrollView(
                        child: Form(
                          key:
                              addTeacherKey, // Assuming you have defined a GlobalKey<FormState>
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: controller.teacherNameController,
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
                                  labelText: 'Teacher Name',
                                  hintText:
                                      'Enter the full name of the teacher',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Teacher\'s name is required.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: controller.teacherEmailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  labelText: 'Email',
                                  hintText:
                                      'Enter the teacher\'s email address',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'A valid email is required.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: controller.teacherCNICController,
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
                                      'Enter the CNIC number (without dashes)',
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
                                controller: controller.teacherContactController,
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
                              TextFormField(
                                controller: controller.teacherAddressController,
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
                                  hintText: 'Enter the teacher\'s address',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Address is required.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              Obx(() {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Text(' Gender:',
                                        style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                      controller.selectedGender
                                                                  .value
                                                                  .toString() ==
                                                              'Male'
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Colors.white),
                                              fixedSize:
                                                  const WidgetStatePropertyAll(
                                                      Size(120, 45)),
                                              shape: WidgetStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(10))),
                                              side: WidgetStatePropertyAll(BorderSide(color: Theme.of(context).primaryColor, width: 2))),
                                          onPressed: () {
                                            controller.selectedGender.value =
                                                'Male';
                                          },
                                          child: Text(
                                            'Male',
                                            style: TextStyle(
                                                color: controller.selectedGender
                                                            .value
                                                            .toString() ==
                                                        'Male'
                                                    ? Colors.white
                                                    : Theme.of(context)
                                                        .primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                controller.selectedGender.value
                                                            .toString() ==
                                                        'Female'
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Colors.white,
                                              ),
                                              fixedSize:
                                                  const WidgetStatePropertyAll(
                                                      Size(120, 45)),
                                              shape: WidgetStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                              side: WidgetStatePropertyAll(
                                                  BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      width: 2))),
                                          onPressed: () {
                                            controller.selectedGender.value =
                                                'Female';
                                          },
                                          child: Text(
                                            'Female',
                                            style: TextStyle(
                                                color: controller.selectedGender
                                                            .value
                                                            .toString() ==
                                                        'Female'
                                                    ? Colors.white
                                                    : Theme.of(context)
                                                        .primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                              const SizedBox(height: 10),
                              Obx(() {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Text(' Teacher Type:',
                                        style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                      controller.selectedType
                                                                  .value
                                                                  .toString() ==
                                                              'Dept'
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Colors.white),
                                              fixedSize:
                                                  const WidgetStatePropertyAll(
                                                      Size(120, 45)),
                                              shape: WidgetStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(10))),
                                              side: WidgetStatePropertyAll(BorderSide(color: Theme.of(context).primaryColor, width: 2))),
                                          onPressed: () {
                                            controller.selectedType.value =
                                                'Dept';
                                          },
                                          child: Text(
                                            'Dept',
                                            style: TextStyle(
                                                color: controller
                                                            .selectedType.value
                                                            .toString() ==
                                                        'Dept'
                                                    ? Colors.white
                                                    : Theme.of(context)
                                                        .primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                controller.selectedType.value
                                                            .toString() ==
                                                        'Visitor'
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Colors.white,
                                              ),
                                              fixedSize:
                                                  const WidgetStatePropertyAll(
                                                      Size(120, 45)),
                                              shape: WidgetStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                              side: WidgetStatePropertyAll(
                                                  BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      width: 2))),
                                          onPressed: () {
                                            controller.selectedType.value =
                                                'Visitor';
                                          },
                                          child: Text(
                                            'Visitor',
                                            style: TextStyle(
                                                color: controller
                                                            .selectedType.value
                                                            .toString() ==
                                                        'Visitor'
                                                    ? Colors.white
                                                    : Theme.of(context)
                                                        .primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (addTeacherKey.currentState!.validate()) {
                      controller.addTeacher(widget.deptName);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Add Teacher',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Future showExcelBottomSheet(BuildContext context) {
    List<String> columns = [
      "Teacher Name",
      "Email",
      "CNIC",
      "Contact No",
      "Address",
      "Type",
      "Gender",
    ];
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
                'Add Teachers',
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
                  controller
                      .fetchTeachersFromExcel(widget.deptName)
                      .then((futureList) {
                    if (futureList.isNotEmpty) {
                      controller.addTeacherList(futureList);
                    }
                  });
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
}
