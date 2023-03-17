import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sp_frontend/auth/auth_provider.dart';
import 'package:sp_frontend/components/custom_input.dart';
import 'package:sp_frontend/components/custom_scackbar.dart';
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
  bool _loginMode = true;
  bool _isObscure = true;
  bool _isLoading = false;

  void _errorPopup(String message, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(customSnackBar(context, message));
  }

  void _callback(BuildContext context) async {
    String userId = _userIdCtrlr.text.trim();
    String password = _passwordCtrlr.text;
    String name = _nameCtrlr.text.trim();
    String email = _emailCtrlr.text.trim();

    final auth = context.read<AuthProvider>();

    if (_loginMode) {
      if (userId.isEmpty || password.isEmpty) {
        _errorPopup("Please fill all the fields", context);
        return;
      }
      _toggleLoading();
      auth.login(userId, password).then((error) => {
            if (error != null)
              {
                _errorPopup(error, context),
                _toggleLoading(),
              }
            else
              {
                Navigator.of(context).pushReplacementNamed('/'),
              }
          });
    } else {
      if (userId.isEmpty || password.isEmpty || name.isEmpty || email.isEmpty) {
        _errorPopup("Please fill all the fields", context);
        return;
      }

      if (!emailRegex.hasMatch(email)) {
        _errorPopup("Please enter a valid email address", context);
        return;
      }

      _toggleLoading();

      auth.signUp(userId, password, name, email).then((error) => {
            if (error != null)
              {
                _errorPopup(error, context),
                _toggleLoading(),
              }
            else
              {
                Navigator.of(context).pushReplacementNamed('/'),
              }
          });
    }
  }

  void _toggleMode(BuildContext context) {
    setState(() {
      _loginMode = !_loginMode;
    });
  }

  void _toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
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
              const SizedBox(height: 50),
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
                      "Split your bills easily",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 40),
                    CustomInput(
                      controller: _userIdCtrlr,
                      hintText: "User ID",
                      color: Palette.alphaLight,
                    ),
                    if (!_loginMode) ...[
                      CustomInput(
                        controller: _nameCtrlr,
                        hintText: "Full Name",
                        color: Palette.alphaLight,
                      ),
                      CustomInput(
                        controller: _emailCtrlr,
                        hintText: "Email Address",
                        color: Palette.alphaLight,
                      ),
                    ],
                    Stack(
                      children: [
                        CustomInput(
                          isPassword: _isObscure,
                          controller: _passwordCtrlr,
                          hintText: "Password",
                          color: Palette.alphaLight,
                        ),
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
                    _isLoading
                        ? const SpinKitPulse(
                            color: Palette.beta,
                            size: 55.0,
                          )
                        : MediumButton(
                            callback: () => _callback(context),
                            text: _loginMode ? "Login" : "Sign Up",
                            color: Palette.alpha,
                            icon: Icons.login),
                    TextButton(
                      onPressed: () => _toggleMode(context),
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            Palette.alpha.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _loginMode
                                ? "Don't have an account? "
                                : "Already have an account?",
                            style: const TextStyle(color: Palette.alphaDark),
                          ),
                          Text(
                            _loginMode ? "Sign Up" : "Login",
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                color: Palette.beta,
                                decorationColor: Palette.beta),
                          ),
                        ],
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
