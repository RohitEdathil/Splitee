import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sp_frontend/components/medium_button.dart';
import 'package:sp_frontend/group/group_provider.dart';
import 'package:sp_frontend/theme/colors.dart';

class SimplifyScreen extends StatefulWidget {
  final String groupId;
  const SimplifyScreen({super.key, required this.groupId});

  @override
  State<SimplifyScreen> createState() => _SimplifyScreenState();
}

class _SimplifyScreenState extends State<SimplifyScreen> {
  bool _isLoading = false;

  void _simplify(BuildContext context) async {
    final group = context.read<GroupProvider>();

    setState(() {
      _isLoading = true;
    });

    await group.redistribute(widget.groupId);
    await group.fetchGroup(widget.groupId);

    setState(() {
      _isLoading = false;
    });

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _isLoading
            ? const SizedBox(
                height: 30,
                child: SpinKitPulse(
                  color: Palette.alpha,
                  size: 30,
                ),
              )
            : MediumButton(
                color: Palette.alpha,
                icon: Icons.auto_fix_high_rounded,
                text: "Simplify",
                callback: () => _simplify(context)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "Magic Simplify",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 20),
              SizedBox(
                  height: 200,
                  child: Transform.scale(
                      scale: 2,
                      child: LottieBuilder.asset("assets/magic.json"))),
              Padding(
                padding: const EdgeInsets.all(35.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                        "Re-organizes all the payments of this group into a set of simplified bills"),
                    SizedBox(height: 10),
                    BulletPoint(text: "Will delete all the current bills"),
                    BulletPoint(text: "Create new simplified bills"),
                    BulletPoint(text: "Won't change the overall balances"),
                    SizedBox(height: 10),
                    Text("Press \"Simplify\" to proceed")
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.check,
            color: Palette.alpha,
            size: 17,
          ),
        ),
        Expanded(child: Text(text))
      ],
    );
  }
}
