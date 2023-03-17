import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sp_frontend/bill/components/add_from_group.dart';
import 'package:sp_frontend/components/custom_input.dart';
import 'package:sp_frontend/components/user_display.dart';
import 'package:sp_frontend/group/group_modal.dart';
import 'package:sp_frontend/theme/colors.dart';
import 'package:sp_frontend/user/user_modal.dart';
import 'package:sp_frontend/user/user_provider.dart';

class BillCreateScreen extends StatefulWidget {
  final Group? group;
  const BillCreateScreen({super.key, this.group});

  @override
  State<BillCreateScreen> createState() => _BillCreateScreenState();
}

class _BillCreateScreenState extends State<BillCreateScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  final Map<BaseUser, TextEditingController> _participants = {};

  bool _isPercentage = false;

  void _setPercentage(bool value) {
    setState(() {
      _isPercentage = value;
    });
  }

  void _editParticipants(BuildContext context) async {
    if (widget.group == null) {
      // TODO: Groupless bills
      return;
    }

    final currentParticipants = _participants.keys.toList();

    await showModalBottomSheet<List<BaseUser>>(
        context: context,
        builder: (_) =>
            AddFromGroup(group: widget.group!, users: currentParticipants));

    for (final participant in currentParticipants) {
      _participants[participant] = TextEditingController(text: "0");
    }

    _participants.removeWhere(
        (participant, _) => !currentParticipants.contains(participant));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>();
    final currentUser = user.currentUser;

    if (!_participants.containsKey(currentUser)) {
      _participants[currentUser!] = TextEditingController(text: "0");
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Bill'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Inputs
                CustomInput(
                  color: Palette.alphaLight,
                  controller: _nameController,
                  hintText: "Title",
                ),
                const SizedBox(width: 20),
                CustomInput(
                  controller: _amountController,
                  hintText: "Amount",
                  color: Palette.alphaLight,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),

                // % or ₹
                Row(
                  children: [
                    ChoiceChip(
                      selected: !_isPercentage,
                      onSelected: (_) => _setPercentage(false),
                      label: const Text("₹"),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      selected: _isPercentage,
                      onSelected: (_) => _setPercentage(true),
                      label: const Text("%"),
                    )
                  ],
                ),

                // Participants header
                Row(
                  children: [
                    Expanded(
                      child: Text("Participants",
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),

                    // Add participant button
                    TextButton(
                      onPressed: () => _editParticipants(context),
                      child: const Text("Edit"),
                    ),

                    // Split equally button
                    TextButton(
                      onPressed: () {},
                      child: const Text("Split Equally"),
                    )
                  ],
                ),
                for (final participant in _participants.entries)
                  Row(
                    children: [
                      UserDispaly(user: participant.key),
                      const Spacer(),
                      const Text("₹"),
                      SizedBox(
                        width: 70,
                        child: TextField(controller: participant.value),
                      )
                    ],
                  )
              ],
            ),
          ),
        ));
  }
}
