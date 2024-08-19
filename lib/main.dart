import 'package:digital_academic_portal/shared/presentation/pages/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/admin/shared/departments/presentation/bindings/DepartmentBindings.dart';
import 'features/admin/shared/departments/presentation/pages/DepartmentPage.dart';
import 'features/auth/presentation/bindings/AuthBinding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digital Academic Portal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF145849)),
        primaryColor: const Color(0xFF145849),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF145849),
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Ubuntu', fontWeight: FontWeight.bold)
        )
      ),
      initialBinding: AuthBinding(),
      getPages: [
        GetPage(
            name: '/departments',
            page: () => const DepartmentPage(),
          binding: DepartmentBinding()
        )
      ],
      home: const SplashScreen(),
    );
  }
}


class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {

    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for windows - '
            'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;

      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );

      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );

      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );

      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );

    }
  }

  static const FirebaseOptions android = FirebaseOptions(
      apiKey: "AIzaSyBu3YCSGvdi_iH0eCpYIH3XL_sfE3yWdgY",
      appId: '1:849792758725:android:10b9b0b477898c6a8911ac',
      messagingSenderId: '849792758725',
      projectId: 'digital-academic-portal',
      storageBucket: 'digital-academic-portal.appspot.com'
  );

  static const FirebaseOptions ios = FirebaseOptions(
      apiKey: "AIzaSyCQTEbgi-zFbwqcv922K1zmrMXTMFmNu6U",
      appId: '1:849792758725:ios:3f0b2a778608e17a8911ac',
      messagingSenderId: '849792758725',
      projectId: 'digital-academic-portal',
      storageBucket: 'digital-academic-portal.appspot.com'
  );
}
