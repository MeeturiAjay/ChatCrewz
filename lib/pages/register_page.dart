import 'package:firebasechatapplatest/pages/introscreens/splashscreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../helper/helper_function.dart';
import '../service/auth_service.dart';
import '../shared/app_colors.dart';
import '../widgets/widgets.dart';
import 'auth/login_page.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
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
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  textAlign: TextAlign.center,
                  "Where every message sparks a connection. Register now!",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                Lottie.asset("assets/animations/register.json"),
                TextFormField(
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white), // Text color
                  decoration: textInputDecoration.copyWith(
                    labelText: "Full Name",
                    labelStyle: TextStyle(color: Colors.white), // Label text color
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      fullName = val;
                    });
                  },
                  validator: (val) {
                    if (val!.isNotEmpty) {
                      return null;
                    } else {
                      return "Name cannot be empty";
                    }
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white), // Text color
                  decoration: textInputDecoration.copyWith(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white), // Label text color
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
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
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white), // Text color
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white), // Label text color
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                  ),
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
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                    onPressed: () {
                      register();
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Login now",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            nextScreen(context, const LoginPage());
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          // saving the shared preference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackbar(context, Colors.white, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
