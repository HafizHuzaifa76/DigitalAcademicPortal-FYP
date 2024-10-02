
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AdministratorDashboardPage extends StatefulWidget {
  const AdministratorDashboardPage({super.key});

  @override
  State<AdministratorDashboardPage> createState() => _AdministratorDashboardPageState();
}

class _AdministratorDashboardPageState extends State<AdministratorDashboardPage> {
  int count = 0;
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
                padding: const EdgeInsets.only(top: 35, left: 15, right: 15, bottom: 8),
                decoration: const BoxDecoration(
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 80,
                      child: Stack(
                        children: [
                          Positioned(
                              top: 20,
                              right: 100,
                              left: 100,
                              child: Text('Administrator\nDashboard', style: Theme.of(context).appBarTheme.titleTextStyle, textAlign: TextAlign.center,)
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

                                    },
                                    icon: const Icon(Icons.sort, color: Colors.white, size: 28,)
                                ),
                              ),

                              IconButton(
                                icon: const CircleAvatar(
                                  child: Icon(FontAwesomeIcons.userShield),
                                ),
                                onPressed: () => _showCustomMenu(context),
                              ),
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
                              child: Text('Departments\n$count', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu', color: Theme.of(context).primaryColorDark), textAlign: TextAlign.center,),
                            ),
                          ),
                        ),

                        Card(
                          color: const Color(0xFF128771),
                          child: SizedBox(
                            height: 70,
                            width: screenSize.width * 0.28,
                            child: Center(
                              child: Text('Teachers\n$count', style: TextStyle(fontSize: 17, color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'), textAlign: TextAlign.center,),
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
                                Text('Students\n$count', style: TextStyle(fontSize: 17, color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'), textAlign: TextAlign.center,),
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

                    Column(
                      children: [
                        SizedBox(
                            height: 120,
                            child: Image.asset('assets/images/DAP logo.png')
                        ),
                        const SizedBox(height: 7),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Digital', style: TextStyle(fontFamily: 'Belanosima', color: Theme.of(context).primaryColor, fontSize: 23, fontWeight: FontWeight.bold),),
                            const Text(' Academic ', style: TextStyle(fontFamily: 'Belanosima', color: Colors.black, fontSize: 23, fontWeight: FontWeight.bold),),
                            Text('Portal', style: TextStyle(fontFamily: 'Belanosima', color: Theme.of(context).primaryColor, fontSize: 23, fontWeight: FontWeight.bold),),
                          ],
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
                            fixedSize: MaterialStatePropertyAll(Size(screenSize.width * .3, 100)),
                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 12, vertical: 5))
                          ),
                          onPressed: ()=> Get.toNamed('/departments'),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.account_balance, color: Theme.of(context).primaryColorLight, size: 35,),
                              AutoSizeText('Departments', style: TextStyle(color: Theme.of(context).primaryColorLight, fontFamily: 'Ubuntu', fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1,),
                            ],
                          ),
                        ),

                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
                            fixedSize: MaterialStatePropertyAll(Size(screenSize.width * .3, 100)),
                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                          ),
                          onPressed: ()=> Get.toNamed('/allStudents'),
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
                              fixedSize: MaterialStatePropertyAll(Size(screenSize.width * .3, 100)),
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                          ),
                          onPressed: ()=> Get.toNamed('/allTeachers'),
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
                              fixedSize: MaterialStatePropertyAll(Size(screenSize.width * .3, 100)),
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                          ),
                          onPressed: ()=> Get.toNamed('/allCourses'),
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
                            backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
                            fixedSize: MaterialStatePropertyAll(Size(screenSize.width * .3, 100)),
                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 12, vertical: 5))
                          ),
                          onPressed: ()=> Get.toNamed('/'),
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
                            backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
                            fixedSize: MaterialStatePropertyAll(Size(screenSize.width * .3, 100)),
                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                          ),
                          onPressed: ()=> Get.toNamed('/'),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(FontAwesomeIcons.calendarCheck, color: Theme.of(context).primaryColorDark, size: 35,),
                              AutoSizeText(' Calendar ', style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: 'Ubuntu', fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1,),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
                                fixedSize: MaterialStatePropertyAll(Size(screenSize.width * .3, 100)),
                                shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                            ),
                            onPressed: ()=> Get.toNamed('/'),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(FontAwesomeIcons.robot, color: Colors.white, size: 30,),
                                AutoSizeText(' ChatBot ', style: TextStyle(color: Colors.white, fontFamily: 'Ubuntu', fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1,),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
                              fixedSize: MaterialStatePropertyAll(Size(screenSize.width * .3, 100)),
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 12, vertical: 5))
                            ),
                            onPressed: ()=> Get.toNamed('/'),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.bug_report, color: Colors.white, size: 35,),
                                AutoSizeText(' Reports ', style: TextStyle(color: Colors.white, fontFamily: 'Ubuntu', fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1,),
                              ],
                            ),
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


  void _showCustomMenu(BuildContext context) {
    final RenderBox appBarBox = context.findRenderObject() as RenderBox;
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        appBarBox.size.width,// Adjust the X position to align with the icon
        70, // Adjust the Y position to the bottom of the AppBar
        appBarBox.size.width, // This would be a maximum width after X position
        appBarBox.size.height + 200, // This would be a maximum height after Y position
      ),
      items: [
        PopupMenuItem(
          enabled: false,
          child: Column(
            children: [
              const ListTile(
                title: Text('Hi, Hafiz!'),
                subtitle: Text('hafizm.huzaifa1234gf@gmail.com'),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'), // User's image URL
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Manage your Google Account'),
                onTap: () {
                  Navigator.of(context).pop();
                  // Handle the action
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign out'),
                onTap: () {
                  Navigator.of(context).pop();
                  // Handle the action
                },
              ),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    );
  }
}
