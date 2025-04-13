import 'dart:async';
import 'package:digital_academic_portal/features/auth/presentation/pages/LoginPage.dart';
import 'package:digital_academic_portal/shared/presentation/pages/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashServices {

  void isLogin(BuildContext context) {

    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if(user != null){
      Timer(const Duration(seconds: 4), () async {
        Get.offNamed('/admin');
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    }

    else{
      Timer(const Duration(seconds: 3), (){
        Get.off(() =>const LoginPage());
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
    }

  }

}