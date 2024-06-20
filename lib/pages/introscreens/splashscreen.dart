import 'dart:async';
import 'package:firebasechatapplatest/pages/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebasechatapplatest/pages/Onboarding_screens.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 5),  // Change the duration as needed
          () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>  LoginPage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/animations/plane_animation.json',  // Replace with your Lottie animation file
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
