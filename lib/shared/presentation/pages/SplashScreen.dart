import 'package:digital_academic_portal/core/services/SplashServices.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    SplashServices().isLogin(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      backgroundColor: const Color(0xFF145849).withOpacity(0.9),
                    ),
                  ),
                  Positioned(
                    top: -20,
                    left: 30,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color(0xFF145849).withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                    height: 160,
                    child: Image.asset('assets/images/DAP logo.png')
                ),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Digital', style: TextStyle(fontFamily: 'Belanosima', color: Theme.of(context).primaryColor, fontSize: 25, fontWeight: FontWeight.bold),),
                    const Text(' Academic ', style: TextStyle(fontFamily: 'Belanosima', color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),),
                    Text('Portal', style: TextStyle(fontFamily: 'Belanosima', color: Theme.of(context).primaryColor, fontSize: 25, fontWeight: FontWeight.bold),),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 80,)
          ],
        ),
      ),
    );
  }
}
