
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/StudentPanelController.dart';


class StudentPortalDashboardPage extends StatefulWidget {
  const StudentPortalDashboardPage({super.key});

  @override
  State<StudentPortalDashboardPage> createState() => _StudentPortalDashboardPageState();
}

class _StudentPortalDashboardPageState extends State<StudentPortalDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Panel'),
      ),
    );
  }
}
