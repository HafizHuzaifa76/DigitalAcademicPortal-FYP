
import 'package:auto_size_text/auto_size_text.dart';
import 'package:digital_academic_portal/features/admin/shared/departments/domain/entities/Department.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../domain/entities/Course.dart';

class CourseDetailPage extends StatefulWidget {
  final String deptName;
  final Course course;
  const CourseDetailPage({super.key, required this.deptName, required this.course});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {

  @override
  Widget build(BuildContext context) {
    var dept = widget.deptName;
    var course = widget.course;
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
                decoration: const BoxDecoration(
                ),
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
                                child: Text('$dept\n${course.courseName}', style: Theme.of(context).appBarTheme.titleTextStyle, textAlign: TextAlign.center,)),
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
                              child: Text('Sections\n0', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu', color: Theme.of(context).primaryColorDark), textAlign: TextAlign.center,),
                            ),
                          ),
                        ),

                        Card(
                          color: const Color(0xFF128771),
                          child: SizedBox(
                            height: 70,
                            width: screenSize.width * 0.28,
                            child: Center(
                              child: Text('Teachers\n0', style: TextStyle(fontSize: 17, color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'), textAlign: TextAlign.center,),
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
                                Text('Students\n0', style: TextStyle(fontSize: 17, color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'), textAlign: TextAlign.center,),
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
                                AutoSizeText('Course Code', style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'Ubuntu', fontSize: 17, fontWeight: FontWeight.bold), maxLines: 1,),
                                AutoSizeText(course.courseCode, style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.bold), maxLines: 1,),
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
                                AutoSizeText('Semester', style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.bold), maxLines: 1,),
                                AutoSizeText(course.courseSemester, style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.bold), maxLines: 1,),
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                AutoSizeText('Dept', style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.bold), maxLines: 1,),
                                AutoSizeText(course.courseDept, style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.bold), maxLines: 1,),
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
                                AutoSizeText('Credit Hr', style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.bold), maxLines: 1,),
                                AutoSizeText('${course.courseCreditHours}', style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.bold), maxLines: 1,),
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
                              backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
                              fixedSize: MaterialStatePropertyAll(Size(screenSize.width * .45, 100)),
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                          ),
                          onPressed: ()=> Get.toNamed('/semesterStudents', arguments: {
                            'deptName': dept,
                            'semester': course.courseSemester,
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
                              backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
                              fixedSize: MaterialStatePropertyAll(Size(screenSize.width * .45, 100)),
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                          ),
                          onPressed: ()=> Get.toNamed('/teachers'),
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
                              backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
                              fixedSize: MaterialStatePropertyAll(Size(screenSize.width * .45, 100)),
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                          ),
                          onPressed: () {

                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.account_tree, color: Theme.of(context).primaryColorDark, size: 35,),
                              AutoSizeText(' Sections ', style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: 'Ubuntu', fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1,),
                            ],
                          ),
                        ),

                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
                              fixedSize: MaterialStatePropertyAll(Size(screenSize.width * .45, 100)),
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                          ),
                          onPressed: () {},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.table_view_rounded, color: Theme.of(context).primaryColorDark, size: 35,),
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
}
