// lib/features/auth/presentation/controllers/auth_controller.dart
import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:digital_academic_portal/features/auth/domain/entities/UserEntity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        Utils().showErrorSnackBar(
          'Account Login Error', message,
        );
      }, (userRole) {
        Utils().showSuccessSnackBar(
          'Account Login',
          'Welcome back to your account!'
        );

        Get.offNamed('/$userRole');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isLoading(false);
    }
  }
}

