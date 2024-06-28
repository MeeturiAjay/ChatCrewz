import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasechatapplatest/pages/introscreens/splashscreen.dart';
import 'package:firebasechatapplatest/shared/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../helper/helper_function.dart';
import '../../service/auth_service.dart';
import '../../service/database_service.dart';
import '../../widgets/widgets.dart';
import '../home_page.dart';
import '../register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: _isLoading
          ? Center(
        child: SplashScreen(),
      )
          : SingleChildScrollView(
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "ChatCrewz",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                      "Instantly connect and collaborate with friends, family, and colleagues in real time.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white)),
                  const SizedBox(height: 20),
                  Lottie.asset(
                      "assets/animations/login.json", width: 360, height: 260),
                  const SizedBox(height: 25),
                  TextFormField(
                    style: TextStyle(
                        color: Colors.white
                    ),
                    cursorColor: Colors.white,
                    decoration: textInputDecoration.copyWith(
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.white,
                        )),
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },

                    // check tha validation
                    validator: (val) {
                      return RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val!)
                          ? null
                          : "Please enter a valid email";
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    style: TextStyle(
                        color: Colors.white
                    ),
                    cursorColor: Colors.white,
                    obscureText: true,
                    decoration: textInputDecoration.copyWith(
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        )),
                    validator: (val) {
                      if (val!.length < 6) {
                        return "Password must be at least 6 characters";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: const Text(
                        "Sign In",
                        style:
                        TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                      onPressed: () {
                        login();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text.rich(TextSpan(
                    text: "Don't have an account? ",
                    style: const TextStyle(
                        color: Colors.white, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: "Register here",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              nextScreen(context, const RegisterPage());
                            }),
                    ],
                  )),
                ],
              )),
        ),
      ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      bool loginSuccess = await authService.loginWithUserNameandPassword(
          email, password);

      if (loginSuccess) {
        DocumentSnapshot snapshot = await DatabaseService(
            uid: FirebaseAuth.instance.currentUser!.uid)
            .gettingUserData(email);

        if (snapshot.exists) {
          // Saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot['fullName']);

          // Navigate to the home page
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackbar(context, Colors.white, "User data not found.");
        }
      } else {
        showSnackbar(context, Colors.white, "Login failed.");
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}