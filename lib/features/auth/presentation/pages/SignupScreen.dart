
import 'dart:convert';

import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:digital_academic_portal/main.dart';
import 'package:digital_academic_portal/shared/presentation/pages/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SignupScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SignupScreen_State();
  }

  const SignupScreen({super.key});
}

class SignupScreen_State extends State<SignupScreen> {

  bool _obscureText = true;
  bool loading = false;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Map<String, dynamic> workoutPlanMap = {};

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose(){
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade700,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 315,
                child: const Wrap(children: [Text("Welcome!\nLet's get started...", style: TextStyle(color: Colors.white ,fontFamily: 'Font1', fontSize: 30, fontWeight: FontWeight.w500))]),
              ),
              const SizedBox(height: 35.0),

              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                              ),
                                hintText: ' Email',
                                hintStyle: TextStyle(color: Colors.grey.shade700),
                                prefixIcon: const Icon(Icons.email_outlined, color: Colors.black)
                            ),
                            validator: (value){
                              if(value!.isEmpty){
                                return 'Please enter your email!';
                              }
                              else if(!value.contains("@gmail.com")){
                                return 'Please enter a valid email!';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 15.0),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: passwordController,
                            style: const TextStyle(color: Colors.black),
                            obscureText: _obscureText, // Toggle this value to show/hide password
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                gapPadding: 10
                              ),
                              hintText: ' Password',
                              hintStyle: TextStyle(color: Colors.grey.shade700),
                              prefixIcon: const Icon(Icons.lock_outline, color: Colors.black),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText; // Toggle the value
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password!';
                              } else if (value.length < 6) {
                                return 'Please enter at least 6 characters!';
                              } else if (!(value.contains(RegExp(r'[0-9]')))) {
                                return 'Please add a number 0-9';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text('Note: Only Admin can create account\nEmployees accounts are created by admins', style: TextStyle(fontSize: 15, color: Colors.white)),

                      ],
                    )
                ),
              ),
              const SizedBox(height: 40.0),

              ElevatedButton(
                onPressed: (){
                  if(formKey.currentState!.validate()){
                    setState(() {
                      loading = true;
                    });
                    auth.createUserWithEmailAndPassword(
                        email: emailController.text.toString(),
                        password: passwordController.text.toString(),
                    ).then((value){
                      Utils().toast("Account Created", context);
                      auth.signInWithEmailAndPassword(email: emailController.text.toString(), password: passwordController.text.toString()).then((value) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                      }).onError((error, stackTrace){
                        Utils().toastErrorMessage(error.toString(), context);
                      });
                    }).onError((error, stackTrace){
                      Utils().toastErrorMessage(error.toString(), context);
                      setState(() {
                        loading = false;
                      });
                    });
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  fixedSize: MaterialStateProperty.all(const Size(330,55)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0), // Set your desired border radius
                    ),
                  ),
                ),
                child: loading ? const CircularProgressIndicator(strokeWidth: 3, color: Colors.white) : const Text("Create Account",style: TextStyle(color: Colors.white, fontFamily: 'Font1', fontSize: 20))
              ),
              const SizedBox(height: 15.0),

              Container(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?\nAre you an employee?", style: TextStyle(fontFamily: 'Font1', fontSize: 15, color: Colors.white)),
                    TextButton(
                      onPressed: (){
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => LoginScreen(),
                        //     ),
                        // );
                      },
                      child: Text("Login Now", style: TextStyle(color: Colors.lightBlue.shade300, fontWeight: FontWeight.bold, fontFamily: 'Font1', fontSize: 15)),
                    ),
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