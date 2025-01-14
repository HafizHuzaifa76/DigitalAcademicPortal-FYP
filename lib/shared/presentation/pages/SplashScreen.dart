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
            // Top Animated Circles
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, -50 * (1 - value)),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: SizedBox(
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
            ),

            // Logo with Scaling and Rotation Animation
            Column(
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(seconds: 2),
                  builder: (context, scaleValue, child) {
                    return Transform.scale(
                      scale: scaleValue,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 2 * 3.14159),
                        duration: const Duration(seconds: 2),
                        builder: (context, rotationValue, child) {
                          return Transform.rotate(
                            angle: rotationValue,
                            child: child,
                          );
                        },
                        child: child,
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 160,
                    child: Image.asset('assets/images/DAP logo.png'),
                  ),
                ),
                const SizedBox(height: 7),

                // Row with Staggered Animation for Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _AnimatedText(
                      text: 'Digital',
                      color: Theme.of(context).primaryColor,
                      delay: 500, // Delay in milliseconds
                    ),
                    const _AnimatedText(
                      text: ' Academic ',
                      color: Colors.black,
                      delay: 1000,
                    ),
                    _AnimatedText(
                      text: 'Portal',
                      color: Theme.of(context).primaryColor,
                      delay: 1500,
                    ),
                  ],
                ),
              ],
            ),

            // Spacer for bottom alignment
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _AnimatedText extends StatelessWidget {
  final String text;
  final Color color;
  final int delay;

  const _AnimatedText({
    required this.text,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Belanosima',
          color: color,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
