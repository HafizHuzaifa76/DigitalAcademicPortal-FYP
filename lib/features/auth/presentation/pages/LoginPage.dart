// lib/features/auth/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/AuthController.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  height: 100,
                  child: Stack(
                    children: [
                      Positioned(
                        top: -10,
                        left: -30,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xFF145849).withOpacity(0.9),
                        ),
                      ),
                      Positioned(
                        top: -20,
                        left: 30,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Color(0xFF145849).withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 120,
                        child: Image.asset('assets/images/DAP logo.png')
                    ),
                    SizedBox(height: 7),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Digital', style: TextStyle(fontFamily: 'Belanosima', color: Theme.of(context).primaryColor, fontSize: 23, fontWeight: FontWeight.bold),),
                        Text(' Academic ', style: TextStyle(fontFamily: 'Belanosima', color: Colors.black, fontSize: 23, fontWeight: FontWeight.bold),),
                        Text('Portal', style: TextStyle(fontFamily: 'Belanosima', color: Theme.of(context).primaryColor, fontSize: 23, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: 50),

                    Container(
                      width: 315,
                      child: Wrap(children: [Text("Hey Welcome!\nSign-in to your account", style: TextStyle(color: Theme.of(context).primaryColor ,fontFamily: 'Ubuntu', fontSize: 28, fontWeight: FontWeight.bold))]),
                    ),
                    const SizedBox(height: 15.0),

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
                                  controller: controller.emailController,
                                  cursorColor: Theme.of(context).primaryColor,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                                      fillColor: Colors.black,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      hintText: ' Email',
                                      hintStyle: TextStyle(fontFamily: 'Ubuntu', color: Colors.grey.shade700),
                                      prefixIcon: Icon(Icons.email_outlined, color: Theme.of(context).primaryColor)
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
                                child: Obx(() =>  TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: controller.passwordController,
                                  cursorColor: Theme.of(context).primaryColor,
                                  style: const TextStyle(color: Colors.black),
                                  obscureText: controller.obscureText.value, // Toggle this value to show/hide password
                                  decoration: InputDecoration(
                                    hoverColor: Colors.blue,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        gapPadding: 10
                                    ),
                                    hintText: ' Password',
                                    hintStyle: TextStyle(fontFamily: 'Ubuntu', color: Colors.grey.shade700),
                                    prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).primaryColor),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                          controller.obscureText.value ? Icons.visibility : Icons.visibility_off,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      onPressed: () {
                                          controller.obscureText.value = !controller.obscureText.value; // Toggle the value
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
                              )),
                            ],
                          )
                      ),
                    ),

                    const SizedBox(height: 4.0),
                    TextButton(
                        onPressed: (){

                        },
                        child: Text('Forget Password', style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16),)
                    ),
                    const SizedBox(height: 6.0),

                    ElevatedButton(
                        onPressed: (){
                          if(formKey.currentState!.validate()){
                            controller.login();
                            // final user = FirebaseAuth.instance.currentUser;
                            // print('email: ${user!.email}');
                            // setState(() {
                            //   loading = true;
                            // });
                            // auth.signInWithEmailAndPassword(
                            //     email: emailController.text.toString(),
                            //     password: passwordController.text.toString())
                            //     .then((value) async {
                            //   setState(() {
                            //     loading = false;
                            //   });
                            //   final user = FirebaseAuth.instance.currentUser;

                              // DocumentReference docRef = FirebaseFirestore.instance.collection('drivers').doc(user!.email).collection('vehicles').doc('current_vehicle');
                              // DocumentSnapshot snapshot = await docRef.get();

                              // if(snapshot.exists){
                              //   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardView()));
                              // }
                              // else {
                              // }
                            //   Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                            //   Utils().toast("Welcome", context);
                            // }).onError((error, stackTrace) {
                            //   print('error: $error');
                            //   Utils().toastErrorMessage(error.toString(), context);
                            // });

                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                          fixedSize: MaterialStateProperty.all(const Size(330,55)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0), // Set your desired border radius
                            ),
                          ),
                        ),
                        child: Obx(() =>
                          controller.isLoading.value ? const CircularProgressIndicator(strokeWidth: 3, color: Colors.white) : const Text("Login Now", style: TextStyle(color: Colors.white, fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.w600))
                        )
                    ),
                    const SizedBox(height: 15.0),

                  ],
                ),

                SizedBox()
              ],
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Obx(() {
              if (controller.isLoading.value) {
                return CircularProgressIndicator();
              }

              return ElevatedButton(
                onPressed: () {
                  controller.login();
                },
                child: Text('Login'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
