import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebasechatapplatest/pages/Onboarding_screens.dart';
import 'package:firebasechatapplatest/pages/auth/login_page.dart';
import 'package:firebasechatapplatest/pages/home_page.dart';
import 'package:firebasechatapplatest/firebase_options.dart';
import 'package:firebasechatapplatest/shared/constants.dart';
import 'helper/helper_function.dart';

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
  bool _showOnboarding = false;
  bool _isLoading = true; // Add this to manage loading state

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    await checkFirstRun();
    await getUserLoggedInStatus();
    setState(() {
      _isLoading = false; // Set loading to false once all checks are done
    });
  }

  Future<void> checkFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstRun = prefs.getBool('isFirstRun');

    if (isFirstRun == null || isFirstRun == true) {
      setState(() {
        _showOnboarding = true;
      });
      prefs.setBool('isFirstRun', false);
    }
  }

  Future<void> getUserLoggedInStatus() async {
    bool? isLoggedIn = await HelperFunctions.getUserLoggedInStatus();
    if (isLoggedIn != null) {
      setState(() {
        _isSignedIn = isLoggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        theme: ThemeData(
          primaryColor: Constants().primaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      theme: ThemeData(
        primaryColor: Constants().primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: _showOnboarding
          ? const OnBoardingScreens()
          : _isSignedIn
          ? const HomePage()
          : const LoginPage(),
    );
  }
}
