import 'dart:async';

import 'package:firebasechatapplatest/pages/Onboarding_screens.dart';
import 'package:firebasechatapplatest/pages/auth/login_page.dart';
import 'package:firebasechatapplatest/pages/home_page.dart';
import 'package:firebasechatapplatest/pages/introscreens/splashscreen.dart';
import 'package:firebasechatapplatest/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasechatapplatest/firebase_options.dart';
import 'package:firebasechatapplatest/shared/constants.dart';
import 'package:flutter/foundation.dart';

import 'helper/helper_function.dart';  // Import Lottie package

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Constants().primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),  // Use SplashScreen as the initial route
    );
  }
}
