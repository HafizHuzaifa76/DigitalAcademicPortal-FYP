// lib/features/auth/presentation/controllers/auth_controller.dart
import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:digital_academic_portal/features/auth/domain/entities/UserEntity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/LoginUsecase.dart';
import '../../domain/usecases/ForgetPasswordUseCase.dart';

class AuthController extends GetxController {
  final LoginUseCase loginUsecase;
  final ForgetPasswordUseCase forgetPasswordUsecase;

  AuthController(
      {required this.loginUsecase, required this.forgetPasswordUsecase});

  var isLoading = false.obs;
  var isForgetPasswordLoading = false.obs;
  var obscureText = true.obs;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var forgetPasswordEmailController = TextEditingController();

  Future<void> login() async {
    try {
      isLoading(true);
      final result = await loginUsecase.execute(
          User(email: emailController.text, password: passwordController.text));

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar(
          'Account Login Error',
          message,
        );
      }, (userRole) {
        Utils().showSuccessSnackBar(
            'Account Login', 'Welcome back to your account!');
        print('user: $userRole');
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

  Future<void> forgetPassword() async {
    try {
      isForgetPasswordLoading(true);
      final result = await forgetPasswordUsecase
          .execute(forgetPasswordEmailController.text);

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar(
          'Password Reset Error',
          message,
        );
      }, (successMessage) {
        Utils().showSuccessSnackBar('Password Reset Email', 'Email sent successfully!');
        forgetPasswordEmailController.clear();
        Get.back(); // Go back to login page
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isForgetPasswordLoading(false);
    }
  }
}
