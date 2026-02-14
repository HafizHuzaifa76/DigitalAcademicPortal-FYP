import 'dart:async';
import 'package:digital_academic_portal/features/auth/presentation/pages/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final displayName = user?.displayName ?? '';
    List<String> parts = displayName.split(' | ');

    if (user != null) {
      Timer(const Duration(seconds: 4), () async {
        if (parts[0].contains('student')) {
          Get.offNamed('/studentDashboard');
        } else if (parts[0].contains('teacher')) {
          Get.offNamed('/teacherDashboard');
        } else {
          Get.offNamed('/admin');
        }
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Get.off(() => const LoginPage());
      });
    }
  }
}
