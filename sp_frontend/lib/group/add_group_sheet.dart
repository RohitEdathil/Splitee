import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sp_frontend/components/custom_input.dart';
import 'package:sp_frontend/components/medium_button.dart';
import 'package:sp_frontend/group/group_provider.dart';
import 'package:sp_frontend/theme/colors.dart';
import 'package:sp_frontend/user/user_provider.dart';

class AddGroupSheet extends StatefulWidget {
  const AddGroupSheet({super.key});

  @override
  State<AddGroupSheet> createState() => _AddGroupSheetState();
}

class _AddGroupSheetState extends State<AddGroupSheet> {
  final _nameController = TextEditingController();
  bool _isCreating = false;

  void _create(BuildContext context) async {
    final name = _nameController.text;

    if (name.isEmpty) return;

    final group = context.read<GroupProvider>();
    final user = context.read<UserProvider>();

    setState(() {
      _isCreating = true;
    });

    await group.createGroup(name);
    await user.reload();

    setState(() {
      _isCreating = false;
    });

    if (!mounted) return;

    Navigator.pop(context);
  }

  void _join(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushNamed(context, "/join");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(children: [
        CustomInput(
            controller: _nameController,
            hintText: "Group Name",
            color: Palette.betaLight),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: (MediaQuery.of(context).size.width - 60) / 2,
              child: MediumButton(
                text: "Join",
                color: Palette.alpha,
                callback: () => _join(context),
                icon: Icons.qr_code_scanner,
              ),
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width - 60) / 2,
              child: _isCreating
                  ? const SpinKitPulse(
                      color: Palette.alpha,
                      size: 30.0,
                    )
                  : MediumButton(
                      text: "Create",
                      color: Palette.alpha,
                      callback: () => _create(context),
                      icon: Icons.add),
            ),
          ],
        ),
      ]),
    );
  }
}
