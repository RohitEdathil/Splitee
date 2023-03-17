import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sp_frontend/components/custom_input.dart';
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
  bool _doneOnce = false;

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

  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (!_doneOnce) {
      controller.text = widget.group.name;
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
      OptionButton(
        icon: Icons.qr_code_2,
        onPressed: () {},
        text: "Joining Code",
      ),
      OptionButton(
        icon: Icons.logout,
        onPressed: () {},
        text: "Leave Group",
      ),
    ]);
  }
}

class OptionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  const OptionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return WhitePaddedContainer(
        child: TextButton.icon(
            onPressed: onPressed, icon: Icon(icon), label: Text(text)));
  }
}

class WhitePaddedContainer extends StatelessWidget {
  final Widget child;
  const WhitePaddedContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
