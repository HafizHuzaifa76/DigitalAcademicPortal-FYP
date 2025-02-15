import 'package:auto_size_text/auto_size_text.dart';
import 'package:digital_academic_portal/features/admin/shared/departments/domain/entities/Department.dart';
import 'package:digital_academic_portal/features/admin/shared/departments/presentation/pages/SemesterPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../controllers/DepartmentController.dart';

class DepartmentDetailPage extends StatefulWidget {
  final Department department;
  const DepartmentDetailPage({super.key, required this.department});

  @override
  State<DepartmentDetailPage> createState() => _DepartmentDetailPageState();
}

class _DepartmentDetailPageState extends State<DepartmentDetailPage> {
  final DepartmentController controller = Get.find();
  late Department dept;

  @override
  void initState() {
    dept = widget.department;
    controller.showAllSemesters(dept.departmentName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            children: [
              Container(
                height: screenSize.height * .25,
                width: screenSize.width,
                padding: EdgeInsets.only(top: 35, left: screenSize.width *0.035, right: screenSize.width *0.035, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 80,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 20,
                            child: Container(
                              width: screenSize.width * 0.93,
                                child: Text('Department\n${dept.departmentName}', style: Theme.of(context).appBarTheme.titleTextStyle, textAlign: TextAlign.center,)),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30,
                                child: IconButton(
                                    padding: const EdgeInsets.all(8),
                                    onPressed: (){
                                      Get.back();
                                    },
                                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28,)
                                ),
                              ),

                              // IconButton(
                              //   icon: const CircleAvatar(
                              //     child: Icon(FontAwesomeIcons.userShield),
                              //   ),
                              //   onPressed: () => _showCustomMenu(context),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          color: const Color(0xFF128771),
                          borderOnForeground: true,
                          semanticContainer: true,
                          shadowColor: Colors.black,
                          child: SizedBox(
                            height: 70,
                            width: screenSize.width * 0.30,
                            child: Center(
                              child: Text('Semesters\n${dept.totalSemesters}', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu', color: Theme.of(context).primaryColorDark), textAlign: TextAlign.center,),
                            ),
                          ),
                        ),

                        Card(
                          color: const Color(0xFF128771),
                          child: SizedBox(
                            height: 70,
                            width: screenSize.width * 0.28,
                            child: Center(
                              child: Text('Teachers\n${dept.totalTeachers}', style: TextStyle(fontSize: 17, color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'), textAlign: TextAlign.center,),
                            ),
                          ),
                        ),

                        Card(
                          color: const Color(0xFF128771),
                          surfaceTintColor: Colors.black,
                          shadowColor: Theme.of(context).primaryColorLight,
                          child: SizedBox(
                            height: 70,
                            width: screenSize.width * 0.28,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Students\n${dept.totalStudents}', style: TextStyle(fontSize: 17, color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'), textAlign: TextAlign.center,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              Container(
                height: screenSize.height * .75,
                width: screenSize.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)
                    )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: screenSize.width * 0.4,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Theme.of(context).primaryColor, width: 2)
                          ),
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                AutoSizeText('Dept Code', style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'Ubuntu', fontSize: 17, fontWeight: FontWeight.bold), maxLines: 1,),
                                AutoSizeText(dept.departmentCode, style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.bold), maxLines: 1,),
                              ],
                            ),
                          ),
                        ),

                        Container(
                          width: screenSize.width * 0.4,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Theme.of(context).primaryColor, width: 2)
                          ),
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                AutoSizeText('HOD', style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.bold), maxLines: 1,),
                                AutoSizeText(dept.headOfDepartment, style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.bold), maxLines: 1,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: screenSize.width * 0.4,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Theme.of(context).primaryColor, width: 2)
                          ),
                          child: Card(
                            child: Column(
                              children: [
                                AutoSizeText('Contact', style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.bold), maxLines: 1,),
                                AutoSizeText(dept.contactPhone, style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.bold), maxLines: 1,),
                              ],
                            ),
                          ),
                        ),

                        Container(
                          width: screenSize.width * 0.4,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Theme.of(context).primaryColor, width: 2)
                          ),
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                AutoSizeText('Semesters', style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.bold), maxLines: 1,),
                                AutoSizeText('${dept.totalSemesters}', style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.bold), maxLines: 1,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    const SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                              fixedSize: WidgetStatePropertyAll(Size(screenSize.width * .3, 100)),
                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12, vertical: 5))
                          ),
                          onPressed: ()=> semestersBottomSheet(context),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.account_balance, color: Theme.of(context).primaryColorLight, size: 35,),
                              AutoSizeText('Semesters', style: TextStyle(color: Theme.of(context).primaryColorLight, fontFamily: 'Ubuntu', fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1,),
                            ],
                          ),
                        ),

                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                              fixedSize: WidgetStatePropertyAll(Size(screenSize.width * .3, 100)),
                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                          ),
                          onPressed: ()=> Get.toNamed('/departmentStudents', arguments: {
                            'deptName': dept.departmentName,
                            'deptCode': dept.departmentCode,
                            'semesterList': controller.semestersList,
                          }),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(FontAwesomeIcons.userGraduate, color: Theme.of(context).primaryColorLight, size: 35,),
                              AutoSizeText('Students', style: TextStyle(color: Theme.of(context).primaryColorLight, fontFamily: 'Ubuntu', fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1,),
                            ],
                          ),
                        ),

                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                              fixedSize: WidgetStatePropertyAll(Size(screenSize.width * .3, 100)),
                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                          ),
                          onPressed: ()=> Get.toNamed('/deptTeachers', arguments: {
                            'deptName': dept.departmentName
                          }),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.school, color: Theme.of(context).primaryColorLight, size: 35,),
                              AutoSizeText('Teachers', style: TextStyle(color: Theme.of(context).primaryColorLight, fontFamily: 'Ubuntu', fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1,),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                              fixedSize: WidgetStatePropertyAll(Size(screenSize.width * .3, 100)),
                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                          ),
                          onPressed: ()=> Get.toNamed('/deptCourses', arguments: {
                            'deptName': dept.departmentName,
                            'deptCode': dept.departmentCode,
                            'semesterList': controller.semestersList
                          }),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.book, color: Theme.of(context).primaryColorDark, size: 35,),
                              AutoSizeText(' Courses ', style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: 'Ubuntu', fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1,),
                            ],
                          ),
                        ),

                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                              fixedSize: WidgetStatePropertyAll(Size(screenSize.width * .3, 100)),
                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12, vertical: 5))
                          ),
                          onPressed: ()=> Get.toNamed('/teachers'),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(FontAwesomeIcons.bullhorn, color: Theme.of(context).primaryColorDark, size: 35,),
                              AutoSizeText('Notice Board', style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: 'Ubuntu', fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1,),
                            ],
                          ),
                        ),

                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                              fixedSize: WidgetStatePropertyAll(Size(screenSize.width * .3, 100)),
                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                          ),
                          onPressed: (){

                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Lottie.asset(
                              //   'assets/animations/loading_animation4.json',
                              //   width: 35,
                              //   height: 35,
                              //   fit: BoxFit.scaleDown,
                              // ),

                              //chatbot
                              //move students to next semester
                              Icon(FontAwesomeIcons.calendarCheck, color: Theme.of(context).primaryColorDark, size: 35,),
                              AutoSizeText(' TimeTable ', style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: 'Ubuntu', fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1,),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void semestersBottomSheet(BuildContext context){
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
                  borderRadius: BorderRadius.circular(50)
                ),
              ),
              const SizedBox(height: 6.5),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: controller.semestersList.map((semester) => Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.off(SemesterPage(department: dept, semester: semester.semesterName));
                    },
                    child: Text(semester.semesterName, style: const TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Ubuntu'))
                  ),
                )).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
