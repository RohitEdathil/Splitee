import 'package:flutter/material.dart';
import 'package:sp_frontend/components/custom_input.dart';
import 'package:sp_frontend/components/medium_button.dart';
import 'package:sp_frontend/theme/colors.dart';
import 'package:lottie/lottie.dart';

final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userIdCtrlr = TextEditingController();
  final _passwordCtrlr = TextEditingController();
  final _nameCtrlr = TextEditingController();
  final _emailCtrlr = TextEditingController();
  bool loginMode = true;
  bool _isObscure = true;

  void _errorPopup(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Palette.beta,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _callback(BuildContext context) async {
    String userId = _userIdCtrlr.text.trim();
    String password = _passwordCtrlr.text;
    String name = _nameCtrlr.text.trim();
    String email = _emailCtrlr.text.trim();

    if (loginMode) {
      if (userId.isEmpty || password.isEmpty) {
        _errorPopup("Please fill all the fields", context);
        return;
      }
      // TODO: Login
    } else {
      if (userId.isEmpty || password.isEmpty || name.isEmpty || email.isEmpty) {
        _errorPopup("Please fill all the fields", context);
        return;
      }

      if (!emailRegex.hasMatch(email)) {
        _errorPopup("Please enter a valid email address", context);
        return;
      }
      // TODO: Sign Up
    }
  }

  void _toggleMode(BuildContext context) {
    setState(() {
      loginMode = !loginMode;
    });
  }

  void _toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Transform.scale(
                  scale: 1.3,
                  child: LottieBuilder.asset("assets/login-anim.json",
                      height: 350),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Splitee",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Split your bill easily",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 40),
                    CustomInput(controller: _userIdCtrlr, hintText: "User ID"),
                    if (!loginMode) ...[
                      CustomInput(
                          controller: _nameCtrlr, hintText: "Full Name"),
                      CustomInput(
                          controller: _emailCtrlr, hintText: "Email Address"),
                    ],
                    Stack(
                      children: [
                        CustomInput(
                            isPassword: _isObscure,
                            controller: _passwordCtrlr,
                            hintText: "Password"),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            height: 60,
                            child: IconButton(
                                onPressed: _toggleObscure,
                                icon: Icon(_isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility)),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    MediumButton(
                        callback: () => _callback(context),
                        text: loginMode ? "Login" : "Sign Up",
                        color: Palette.alpha,
                        icon: Icons.login),
                    TextButton(
                      onPressed: () => _toggleMode(context),
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                              Palette.alpha.withOpacity(0.2)),
                          foregroundColor:
                              MaterialStateProperty.all(Palette.beta)),
                      child: Text(
                        loginMode
                            ? "Sign Up if you are new here"
                            : "Login if you have an account",
                        style: const TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Palette.beta),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
