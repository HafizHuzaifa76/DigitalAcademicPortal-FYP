import 'package:auto_size_text/auto_size_text.dart';
import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:digital_academic_portal/features/admin/shared/courses/data/models/SemesterCourseModel.dart';
import 'package:digital_academic_portal/features/admin/shared/courses/domain/entities/DepartmentCourse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../departments/domain/entities/Semester.dart';
import '../../domain/entities/SemesterCourse.dart';
import '../controllers/CourseController.dart';
import 'CourseDetailPage.dart';

class SemesterWiseCourseScreen extends StatefulWidget {
  final String deptName;
  final String deptCode;

  const SemesterWiseCourseScreen({
    super.key,
    required this.deptName,
    required this.deptCode,
  });

  @override
  State<SemesterWiseCourseScreen> createState() => _SemesterWiseCourseScreenState();
}

class _SemesterWiseCourseScreenState extends State<SemesterWiseCourseScreen> {
  final CourseController controller = Get.find();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      controller.updatePadding(scrollController.offset);
    });

    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Theme.of(context).primaryColor,
      //   onPressed: () => semestersBottomSheet(context),
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
         Obx(()=> SliverAppBar(
            expandedHeight: 150.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(bottom: controller.titlePadding.value),
              centerTitle: true,
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Courses',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),

                  Text(
                    'Department of ${widget.deptName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      const Color(0xFF1B7660),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 55,
                      child: TextField(
                        controller: searchController,
                        onChanged: (query) {
                          controller.filterCourses(query);
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(2),
                          hintText: 'Search Courses...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )),

          Obx(() {
            print(controller.filteredSemesterCourseList.length);
            if (controller.isLoading.value) {
              return SliverFillRemaining(
                child: Center(
                  child: Lottie.asset(
                    'assets/animations/loading_animation4.json',
                    width: 120,
                    height: 120,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              );
            } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {

                      final semester = controller.semesterList[index];
                      final semesterCourses = controller.filteredSemesterCourseList
                          .where((course) => course.courseSemester == semester.semesterName)
                          .toList();

                      // Build the list of courses for this semester
                      List<Widget> courseWidgets = semesterCourses.map((course) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ListTile(
                              title: Text(
                                course.courseName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                  fontFamily: 'Ubuntu',
                                ),
                              ),
                              subtitle: Text('Code: ${course.courseCode}, Subject: ${course.courseType}'),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Get.to(() => CourseDetailPage(
                                    deptName: widget.deptName, course: course));
                              },
                            ),
                          ),
                        );
                      }).toList();

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  semester.semesterName.replaceFirst('SEM', 'SEMESTER'),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                    fontFamily: 'Ubuntu',
                                  ),
                                ),

                                // Text(
                                //   'Remaining: ${semester.totalCourses - semesterCourses.length}',
                                //   style: TextStyle(
                                //     fontSize: 15,
                                //     fontWeight: FontWeight.w500,
                                //     color: Theme.of(context).primaryColor,
                                //     fontFamily: 'Ubuntu',
                                //   ),
                                // ),
                                IconButton(
                                    onPressed: (){
                                      if (semester.totalCourses == 0) {
                                        selectCourseOptionsBottomSheet(context, semester);
                                      }
                                      else if(semester.totalCourses <= semester.numOfCourses) {
                                        Utils().showErrorSnackBar(
                                          'Error', 'Limit Already Completed...',
                                        );
                                      }
                                      else {
                                        if (semester.numOfElectiveCourses != 0) {
                                          _showAddCourseOptions(semester);
                                        }
                                        else {
                                          // addCourseBottomSheet(context, semester);
                                          showCourseSelectionBottomSheet(context, semester.totalCourses, semester.semesterName, 'compulsory');
                                        }
                                      }
                                    },
                                    icon: Icon(CupertinoIcons.plus, color: Get.theme.primaryColor,)
                                )
                              ],
                            ),
                            const SizedBox(height: 2),

                            if (semesterCourses.isNotEmpty)
                              ...courseWidgets
                            else
                              Container(
                                width: double.infinity,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColorDark,
                                  borderRadius: BorderRadius.circular(20),

                                ),
                                child: Center(
                                  child: Text(
                                    'No Courses Exist',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).primaryColor,
                                      fontFamily: 'Ubuntu',
                                      fontSize: 17
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                    childCount: controller.semesterList.length,
                  ),
                );

            }
          }),
        ],
      ),
    );
  }

  void _showAddCourseOptions(Semester semester) {
    var electiveCourses = controller.semesterCourseList.where((index) => index.courseSemester == semester.semesterName && index.courseType == 'elective').toList().length;
    var compulsoryCourses = controller.semesterCourseList.where((index) => index.courseSemester == semester.semesterName && index.courseType == 'compulsory').toList().length;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Add Compulsory Course'),
              onTap: () {
                Get.back();
                // addCourseBottomSheet(context, semester);
                if (semester.totalCourses - semester.numOfElectiveCourses > compulsoryCourses) {
                  showCourseSelectionBottomSheet(context, semester.totalCourses - semester.numOfElectiveCourses, semester.semesterName, 'compulsory');
                }
                else {
                  Utils().showErrorSnackBar(
                    'Error', 'Limit Already Completed...',
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.library_books),
              title: const Text('Add Elective Course'),
              onTap: () {
                Get.back();
                if (semester.numOfElectiveCourses > electiveCourses) {
                  addElectiveCourseBottomSheet(context, semester);
                }
                else {
                  Utils().showErrorSnackBar(
                    'Error', 'Limit Already Completed...',
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future addCourseBottomSheet(BuildContext context, Semester semester) async {
    final List<int> creditHoursOptions = [1, 2, 3];
    int selectedCreditHours = creditHoursOptions.last;
    var filteredList = controller.semesterCourseList.where((element) => element.courseSemester == semester.semesterName).toList();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Add Compulsory Course\n${semester.semesterName}',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme
                          .of(context)
                          .primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Courses Added : ${filteredList.length}', style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'Ubuntu', fontSize: 18, fontWeight: FontWeight.bold),),
                            Text('Remaining : ${semester.totalCourses - filteredList.length}', style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'Ubuntu', fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 10),

                        TextField(
                          controller: controller.courseCodeController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            ),
                            labelText: 'Course Code',
                          ),
                        ),
                        const SizedBox(height: 10),

                        TextField(
                          controller: controller.courseNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            ),
                            labelText: 'Course Name',
                          ),
                        ),
                        const SizedBox(height: 10),

                        DropdownButtonFormField<int>(
                          value: selectedCreditHours,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            ),
                            labelText: 'Credit Hours',
                          ),
                          items: creditHoursOptions.map((hours) {
                            return DropdownMenuItem(
                              value: hours,
                              child: Text('$hours Credit Hours'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCreditHours = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 10),

                        TextField(
                          controller: TextEditingController(text: semester.semesterName),
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            ),
                            labelText: 'Course Semester',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: const ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, 45))),
                  onPressed: () {
                    if (filteredList.length < semester.totalCourses) {
                      var newCourse = SemesterCourse(
                        courseCode: '${widget.deptCode}-${controller.courseCodeController.text}',
                        courseName: controller.courseNameController.text,
                        courseDept: widget.deptName,
                        courseCreditHours: selectedCreditHours,
                        courseSemester: semester.semesterName,
                        courseType: 'compulsory',
                      );

                      controller.addCourse(newCourse);
                      Get.back();

                    } else {
                      Utils().showErrorSnackBar(
                          'Error', 'Limit Already Completed...',
                      );
                    }
                  },
                  child: const Text('Add', style: TextStyle(fontFamily: 'Ubuntu', fontSize: 20, color: Colors.white)),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Future addElectiveCourseBottomSheet(BuildContext context, Semester semester) async {
    int selectionCourses = semester.numOfElectiveCourses;
    TextEditingController electiveController = TextEditingController();
    TextEditingController selectionController = TextEditingController(text: '$selectionCourses');
    String selectionDescription = "Enter number of selections";

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
                'Add Elective Courses',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: electiveController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      labelText: "Total Elective Courses",
                      hintText: "Enter total electives",
                    ),
                    onChanged: (value) {
                      setState(() {
                        int total = int.tryParse(value) ?? 0;
                        selectionDescription = total > 0 ? "Select number of courses (1 to $total)" : "Enter number of selections";
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: selectionController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      labelText: "Number of Selection Courses",
                      hintText: selectionDescription,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: const ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(
                      Size(double.maxFinite, 45)),
                ),
                onPressed: () {
                  int totalElectives = int.tryParse(electiveController.text) ?? 0;
                  int numSelections = int.tryParse(selectionController.text) ?? 0;

                  if (numSelections > totalElectives) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Selections cannot exceed total electives")));
                  } else {
                    Get.back();
                    showCourseSelectionBottomSheet(context, totalElectives, semester.semesterName, 'elective');
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         ElectiveCourseScreen(totalElectives: totalElectives),
                    //   ),
                    // );
                  }
                },
                child: const Text(
                  'Next',
                  style: TextStyle(
                      fontFamily: 'Ubuntu', fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
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
              children: [
                Container(
                  height: 7,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                const SizedBox(height: 6.5),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: controller.semesterList.map((semester) =>
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            var filteredCourses = controller.filteredSemesterCourseList.where((course) => course.courseSemester == semester.semesterName).toList();

                            if (semester.totalCourses == 0) {
                              selectCourseOptionsBottomSheet(context, semester);
                            } else {
                              if (semester.numOfElectiveCourses != 0) {
                                _showAddCourseOptions(semester);
                              }
                              else {
                                addCourseBottomSheet(context, semester);
                              }
                            }
                          },
                          child: Text(
                            semester.semesterName,
                            style: const TextStyle(color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Ubuntu'),
                          ),
                        ),
                      )).toList(),
                ),
              ],
            ),
          );
        }
    );
  }

  Future selectCourseOptionsBottomSheet(BuildContext context, Semester currentSemester) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  'Select Courses',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme
                        .of(context)
                        .primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Cupertino Picker for Total Courses
              const Text(
                'Total Courses',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 130,
                child: CupertinoPicker(
                  itemExtent: 30,
                  onSelectedItemChanged: (int value) {
                    controller.updateTotalCourses(value); // Adjust value based on index
                  },
                  scrollController: FixedExtentScrollController(
                    initialItem: 4,
                  ),
                  children: List.generate(
                    10,
                        (index) =>
                        Text(
                          "${index + 1} Courses",
                          style: const TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Cupertino Picker for Elective Courses
              const Text(
                'Number of Elective Courses',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 130,
                child: Obx(() {
                  return CupertinoPicker(
                    itemExtent: 30,
                    onSelectedItemChanged: (int value) {
                      controller.updateElectiveCourses(value); // Adjust value based on index
                    },
                    scrollController: FixedExtentScrollController(
                      initialItem: 3,
                    ),
                    children: List.generate(
                      controller.selectedTotalCourses.value + 1,
                          (index) =>
                          Text(
                            "$index Elective Courses",
                            style: const TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 5),

              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Courses: ${controller.selectedTotalCourses.value}',
                      style: TextStyle(
                        color: Theme
                            .of(context)
                            .primaryColor,
                        fontFamily: 'Ubuntu',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Text(
                      'Compulsory: ${controller.selectedTotalCourses.value - controller.selectedElectiveCourses.value}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Ubuntu',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Text(
                      'Elective: ${controller.selectedElectiveCourses.value}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Ubuntu',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 10),
              // Save Button
              ElevatedButton(
                style: const ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(
                      Size(double.maxFinite, 45)),
                ),
                onPressed: () {
                  Semester updatedSemester = Semester(
                      semesterName: currentSemester.semesterName,
                      sectionLimit: currentSemester.sectionLimit,
                      totalCourses: controller.selectedTotalCourses.value,
                      numOfCourses: currentSemester.numOfCourses,
                      numOfElectiveCourses: controller.selectedElectiveCourses.value,
                      numOfStudents: currentSemester.numOfStudents,
                      numOfTeachers: currentSemester.numOfTeachers
                  );
                  showCourseSelectionDialog(context, currentSemester, updatedSemester);
                },
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 20,
                    color: Colors.white,
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

  showCourseSelectionDialog(BuildContext context, Semester currentSemester, Semester updatedSemester) {
    int totalCourses = updatedSemester.totalCourses, compulsoryCourses = updatedSemester.totalCourses - updatedSemester.numOfElectiveCourses, electiveCourses = updatedSemester.numOfElectiveCourses;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(child: Text('Courses', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),)),
          content: Container(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 70,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Total', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 20),),
                      Text('$totalCourses', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 18),),
                    ],
                  ),
                ),
                Container(color: Colors.black, height: 50, width: 2,),

                SizedBox(
                  width: 105,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Compulsory', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 18),),
                      Text('$compulsoryCourses', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 18),),
                    ],
                  ),
                ),
                Container(color: Colors.black, height: 50, width: 2,),

                SizedBox(
                  width: 80,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Elective', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 20),),
                      Text('$electiveCourses', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 18),),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Column(
              children: [
                OutlinedButton(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                    side: WidgetStatePropertyAll(BorderSide(color: Theme.of(context).primaryColor, width: 2))
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel', style: TextStyle(fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                ElevatedButton(
                  onPressed: () {
                    var semesterIndex = controller.semesterList.indexOf(currentSemester);

                    controller.updateSemester(widget.deptName, semesterIndex, updatedSemester);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Confirm', style: TextStyle(color: Colors.white, fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future showCourseSelectionBottomSheet(BuildContext context, int number, String semester, String courseType) {
    List<DepartmentCourse?> selectedCourses = List.filled(number, null); // To track selected courses
    List<DepartmentCourse> courses = controller.allCoursesList;
    for (var semesterCourse in controller.semesterCourseList) {
      courses.removeWhere((course) => course.courseCode == semesterCourse.courseCode);
    }

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
            left: 8.0,
            right: 8.0,
            top: 16.0,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Courses',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Generate Dropdowns dynamically
                  for (int i = 0; i < number; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: DropdownButtonFormField<DepartmentCourse>(
                        value: selectedCourses[i],
                        decoration: InputDecoration(
                          labelText: 'Course ${i + 1}',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        items: courses.where((course) => !selectedCourses.contains(course) || course == selectedCourses[i])
                            .map((course) => DropdownMenuItem(
                          value: course,
                          child: selectedCourses.contains(course) ? SizedBox(
                              width: Get.width * 0.7,
                              child: AutoSizeText(course.courseName, style: const TextStyle(fontWeight: FontWeight.w500), maxLines: 2, )
                          )
                              : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  width: Get.width * 0.7,
                                  child: AutoSizeText(course.courseName, style: const TextStyle(fontWeight: FontWeight.w500), maxLines: 2, )
                              ),
                              const Divider(),
                            ],
                          ),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCourses[i] = value;
                          });
                        },
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Submit Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      if (selectedCourses.contains(null)) {
                        Get.snackbar("Error", "Please select all courses",
                            backgroundColor: Colors.red, colorText: Colors.white);
                      } else {
                        Get.back(); // Close BottomSheet
                        List<SemesterCourse> nonNullCourses = [];
                         for (var course in selectedCourses) {
                           nonNullCourses.add(SemesterCourse.fromDeptCourse(course!, semester, courseType));
                         }
                        controller.addSemesterCourseList(nonNullCourses);
                        print("Selected Courses: $selectedCourses");
                      }
                    },
                    child: const Text("Confirm Selection", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        );
      },
    );
  }

}

class ElectiveCourseScreen extends StatelessWidget {
  final int totalElectives;

  ElectiveCourseScreen({required this.totalElectives});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Elective Courses'),
      ),
      body: ListView.builder(
        itemCount: totalElectives,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Elective Course ${index + 1}'),
            subtitle: TextField(
              decoration: InputDecoration(
                labelText: 'Course Name for Elective ${index + 1}',
              ),
            ),
          );
        },
      ),
    );
  }
}
