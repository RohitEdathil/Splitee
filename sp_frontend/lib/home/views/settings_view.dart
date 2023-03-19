import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sp_frontend/auth/auth_provider.dart';
import 'package:sp_frontend/components/custom_input.dart';
import 'package:sp_frontend/components/option_button.dart';
import 'package:sp_frontend/components/screen_title.dart';
import 'package:sp_frontend/components/white_padded_container.dart';
import 'package:sp_frontend/theme/colors.dart';
import 'package:sp_frontend/user/user_provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  bool _doneOnce = false;

  bool _changingName = false;
  bool _changingEmail = false;

  void _changeName(BuildContext context) async {
    final user = context.read<UserProvider>();

    final newName = _nameController.text;

    // Validate
    if (newName.isEmpty || newName == user.currentUser!.name) return;

    setState(() {
      _changingName = true;
    });

    await user.changeName(newName);
    await user.reload();

    setState(() {
      _changingName = false;
    });
  }

  void _changeEmail(BuildContext context) async {
    final user = context.read<UserProvider>();

    final newEmail = _emailController.text;
    // Validate
    if (newEmail.isEmpty || newEmail == user.currentUser!.email) return;

    setState(() {
      _changingEmail = true;
    });

    await user.changeEmail(newEmail);
    await user.reload();

    setState(() {
      _changingEmail = false;
    });
  }

  void _logout(BuildContext context) {
    final auth = context.read<AuthProvider>();
    auth.logOut();
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().currentUser!;

    if (!_doneOnce) {
      // Set initial values only once
      _nameController.text = user.name;
      _emailController.text = user.email;
      _doneOnce = true;
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 70.0, left: 20.0, right: 20.0, bottom: 64.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ScreenTitle(title: "Settings"),

            // Name
            WhitePaddedContainer(
                child: Column(
              children: [
                CustomInput(
                    controller: _nameController,
                    hintText: "Name",
                    color: Palette.alphaLight),
                _changingName
                    ? const SpinKitPulse(
                        color: Palette.alpha,
                        size: 48,
                      )
                    : TextButton(
                        onPressed: () => _changeName(context),
                        child: const Text("Change"),
                      )
              ],
            )),
            // Email
            WhitePaddedContainer(
                child: Column(
              children: [
                CustomInput(
                    controller: _emailController,
                    hintText: "Email ID",
                    color: Palette.alphaLight),
                _changingEmail
                    ? const SpinKitPulse(
                        color: Palette.alpha,
                        size: 48,
                      )
                    : TextButton(
                        onPressed: () => _changeEmail(context),
                        child: const Text("Change"),
                      )
              ],
            )),
            // Logout
            OptionButton(
                text: "Logout",
                icon: Icons.logout,
                onPressed: () => _logout(context))
          ],
        ),
      ),
    );
  }
}
