// lib/features/auth/presentation/pages/forget_password_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/AuthController.dart';

class ForegetPasswordScreen extends StatefulWidget {
  const ForegetPasswordScreen({super.key});

  @override
  State<ForegetPasswordScreen> createState() => _ForegetPasswordScreenState();
}

class _ForegetPasswordScreenState extends State<ForegetPasswordScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find();
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: Stack(
                    children: [
                      Positioned(
                        top: -10,
                        left: -30,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              const Color(0xFF145849).withOpacity(0.9),
                        ),
                      ),
                      Positioned(
                        top: -20,
                        left: 30,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor:
                              const Color(0xFF145849).withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 120,
                        child: Image.asset('assets/images/DAP logo.png')),
                    const SizedBox(height: 7),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Digital',
                          style: TextStyle(
                              fontFamily: 'Belanosima',
                              color: Theme.of(context).primaryColor,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          ' Academic ',
                          style: TextStyle(
                              fontFamily: 'Belanosima',
                              color: Colors.black,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Portal',
                          style: TextStyle(
                              fontFamily: 'Belanosima',
                              color: Theme.of(context).primaryColor,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    SizedBox(
                      width: 315,
                      child: Wrap(children: [
                        Text("Forgot Password?\nReset your password",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontFamily: 'Ubuntu',
                                fontSize: 24,
                                fontWeight: FontWeight.bold))
                      ]),
                    ),
                    const SizedBox(height: 5.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 16.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              const Color(0xFF1B7660),
                              const Color(0xFF145849),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Form title
                              const Text(
                                'Reset Password',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Ubuntu',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Enter your email to receive a password reset link',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontFamily: 'Ubuntu',
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Email field
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller:
                                    controller.forgetPasswordEmailController,
                                cursorColor: Theme.of(context).primaryColor,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontFamily: 'Ubuntu',
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: 'Ubuntu',
                                    fontSize: 13,
                                  ),
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    color: Colors.grey[400],
                                    fontSize: 13,
                                  ),
                                  prefixIcon: Container(
                                    margin: const EdgeInsets.all(8),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.email_outlined,
                                      color: Theme.of(context).primaryColor,
                                      size: 18,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.grey[300]!),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.grey[300]!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email!';
                                  } else if (!value.contains("@gmail.com")) {
                                    return 'Please enter a valid email!';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // Reset Password button
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      controller.forgetPassword();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor:
                                        Theme.of(context).primaryColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    shadowColor: Colors.black.withOpacity(0.1),
                                  ),
                                  child: Obx(() =>
                                      controller.isForgetPasswordLoading.value
                                          ? SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            )
                                          : const Text(
                                              "Send Reset Link",
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontFamily: 'Ubuntu',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Back to login
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text(
                                    'Back to Login',
                                    style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    // Additional info
                    Text(
                      'Password reset for Digital Academic Portal',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor.withOpacity(0.8),
                        fontFamily: 'Ubuntu',
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
