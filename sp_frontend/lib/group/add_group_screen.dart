import 'package:flutter/material.dart';
import 'package:sp_frontend/components/custom_input.dart';
import 'package:sp_frontend/components/medium_button.dart';
import 'package:sp_frontend/theme/colors.dart';

class AddGroupSheet extends StatefulWidget {
  const AddGroupSheet({super.key});

  @override
  State<AddGroupSheet> createState() => _AddGroupSheetState();
}

class _AddGroupSheetState extends State<AddGroupSheet> {
  final _nameController = TextEditingController();
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
                callback: () {},
                icon: Icons.qr_code_scanner,
              ),
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width - 60) / 2,
              child: MediumButton(
                  text: "Create",
                  color: Palette.beta,
                  callback: () {},
                  icon: Icons.add),
            ),
          ],
        ),
      ]),
    );
  }
}
