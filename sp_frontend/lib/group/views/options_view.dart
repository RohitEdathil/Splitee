import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sp_frontend/components/custom_input.dart';
import 'package:sp_frontend/components/option_button.dart';
import 'package:sp_frontend/components/white_padded_container.dart';
import 'package:sp_frontend/group/components/view_common.dart';
import 'package:sp_frontend/group/group_modal.dart';
import 'package:sp_frontend/group/group_provider.dart';
import 'package:sp_frontend/theme/colors.dart';
import 'package:sp_frontend/user/user_provider.dart';

class OptionsView extends StatefulWidget {
  final Group group;
  const OptionsView({super.key, required this.group});

  @override
  State<OptionsView> createState() => _OptionsViewState();
}

class _OptionsViewState extends State<OptionsView> {
  bool _changingName = false;
  bool _leavingGroup = false;
  bool _doneOnce = false;

  late QrImage _qrImage;

  void _leaveGroup(BuildContext context) async {
    final groupProvider = context.read<GroupProvider>();
    final user = context.read<UserProvider>();

    setState(() {
      _leavingGroup = true;
    });

    await groupProvider.leaveGroup(widget.group.id);
    await user.reload();

    setState(() {
      _leavingGroup = false;
    });

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void _changeName(BuildContext context) async {
    final groupProvider = context.read<GroupProvider>();
    final user = context.read<UserProvider>();

    final newName = controller.text;
    if (newName.isEmpty || newName == widget.group.name) return;

    setState(() {
      _changingName = true;
    });

    await groupProvider.changeName(widget.group.id, newName);

    await Future.wait([
      groupProvider.fetchGroup(widget.group.id),
      user.reload(),
    ]);

    setState(() {
      _changingName = false;
    });
  }

  String _generateData() {
    return jsonEncode({
      "id": widget.group.id,
      "name": widget.group.name,
    });
  }

  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (!_doneOnce) {
      controller.text = widget.group.name;
      _qrImage = QrImage(
        data: _generateData(),
        version: QrVersions.auto,
        size: 200,
        foregroundColor: Palette.alpha,
      );
      _doneOnce = true;
    }

    return ViewCommons(title: "Options", children: [
      WhitePaddedContainer(
          child: Column(
        children: [
          CustomInput(
              controller: controller,
              hintText: "Group Name",
              color: Palette.alphaLight),
          _changingName
              ? const SpinKitPulse(
                  color: Palette.alpha,
                  size: 48,
                )
              : TextButton(
                  onPressed: () => _changeName(context),
                  child: const Text("Change Name"),
                )
        ],
      )),
      WhitePaddedContainer(
          child: Column(children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Scan to join"),
        ),
        _qrImage,
      ])),
      _leavingGroup
          ? const SpinKitPulse(
              color: Palette.alpha,
              size: 48,
            )
          : OptionButton(
              icon: Icons.logout,
              onPressed: () => _leaveGroup(context),
              text: "Leave Group",
            ),
    ]);
  }
}
