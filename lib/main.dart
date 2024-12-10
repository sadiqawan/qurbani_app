import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medally_pro/views/splash_view/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDkfCdpv_V4-mDfMkLylw7B-7GKs1ZJApQ',
      appId: '1:295050447190:android:d9cab16e55a73d1950eef7',
      messagingSenderId: '295050447190',
      projectId: 'newapp-2580d',
      storageBucket: 'newapp-2580d.appspot.com',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MedallyPro',
            theme: ThemeData(
              primarySwatch: Colors.cyan,
            ),
            home: const SplashScreen());
      },
    );
  }
}
