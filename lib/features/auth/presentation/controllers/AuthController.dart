// lib/features/auth/presentation/controllers/auth_controller.dart
import 'package:digital_academic_portal/features/auth/domain/entities/UserEntity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../shared/presentation/pages/HomeScreen.dart';
import '../../domain/usecases/LoginUsecase.dart';

class AuthController extends GetxController {
  final LoginUseCase loginUsecase;

  AuthController({required this.loginUsecase});

  var isLoading = false.obs;
  var obscureText = true.obs;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future<void> login() async {
    try {
      isLoading(true);
      final result = await loginUsecase.execute(User(email: emailController.text, password: passwordController.text));

      result.fold((left) {
        String message = left.failure.toString();
        Get.snackbar(
            'Account Login Error', message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            icon: Icon(CupertinoIcons.clear_circled_solid, color: Colors.white,)
        );
      }, (right) {
        Get.snackbar(
            'Account Login',
            'Welcome back to your account!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.primaryColor,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            colorText: Colors.white,
            icon: Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white,)
        );
        Get.to(HomeScreen());
      });
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}

