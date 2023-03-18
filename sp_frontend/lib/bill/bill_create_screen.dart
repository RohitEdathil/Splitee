import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sp_frontend/bill/bill_modal.dart';
import 'package:sp_frontend/bill/bill_provider.dart';
import 'package:sp_frontend/bill/components/add_from_group.dart';
import 'package:sp_frontend/components/custom_input.dart';
import 'package:sp_frontend/components/custom_scackbar.dart';
import 'package:sp_frontend/components/medium_button.dart';
import 'package:sp_frontend/components/user_display.dart';
import 'package:sp_frontend/components/white_padded_container.dart';
import 'package:sp_frontend/group/group_modal.dart';
import 'package:sp_frontend/group/group_provider.dart';
import 'package:sp_frontend/theme/colors.dart';
import 'package:sp_frontend/user/user_modal.dart';
import 'package:sp_frontend/user/user_provider.dart';

class BillCreateScreen extends StatefulWidget {
  final Group? group;
  final Bill? bill;
  const BillCreateScreen({super.key, this.group, this.bill});

  @override
  State<BillCreateScreen> createState() => _BillCreateScreenState();
}

class _BillCreateScreenState extends State<BillCreateScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  bool _isLoading = false;

  final Map<BaseUser, TextEditingController> _participants = {};

  bool _isPercentage = false;

  bool get _isEditing => widget.bill != null;

  @override
  void initState() {
    super.initState();
    if (!_isEditing) return;

    _nameController.text = widget.bill!.title;
    _amountController.text = widget.bill!.amount.toString();

    for (var owe in widget.bill!.owes) {
      _participants[owe.debtor] =
          TextEditingController(text: owe.amount.toString());
    }
  }

  void _setPercentage(bool value) {
    for (var participant in _participants.entries) {
      if (value) {
        participant.value.text = _percentageFromValue(participant.value);
      } else {
        participant.value.text = _valueFromPercentage(participant.value);
      }
    }

    setState(() {
      _isPercentage = value;
    });
  }

  void _splitEqually() {
    if (_amountController.text.isEmpty) return;

    final amount =
        _isPercentage ? 100 : double.tryParse(_amountController.text) ?? 0;
    final count = _participants.length;

    for (var participant in _participants.entries) {
      participant.value.text = (amount / count).toString();
    }
    setState(() {});
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
      if (_participants.containsKey(participant)) continue;
      _participants[participant] = TextEditingController(text: "0");
    }

    _participants.removeWhere(
        (participant, _) => !currentParticipants.contains(participant));

    setState(() {});
  }

  String _valueFromPercentage(TextEditingController controller,
      {bool round = false}) {
    if (_amountController.text.isEmpty) return "0.0";

    final perc = double.tryParse(controller.text);

    if (perc == null) {
      controller.text = "0";
      return "0";
    }

    if (round) {
      return (perc * (double.tryParse(_amountController.text) ?? 0) / 100)
          .toStringAsFixed(2)
          .toString();
    }
    return (perc * (double.tryParse(_amountController.text) ?? 0) / 100)
        .toString();
  }

  String _percentageFromValue(TextEditingController controller) {
    if (_amountController.text.isEmpty) return "0.0";

    final value = double.tryParse(controller.text) ?? 0;

    return (value * 100 / (double.tryParse(_amountController.text) ?? 0))
        .toString();
  }

  void _reCalculate() {
    setState(() {});
  }

  double _sum() {
    double s = 0;

    for (var value in _participants.values) {
      s += double.tryParse(value.text) ?? 0;
    }

    return s;
  }

  bool _isValid() => _isPercentage
      ? _sum() == 100.0
      : _sum().toStringAsFixed(2) ==
          double.tryParse(_amountController.text)?.toStringAsFixed(2);

  void _errorPopup(String message, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(customSnackBar(context, message));
  }

  void _createOrSave(BuildContext context) async {
    if (!_isValid()) {
      _errorPopup("Sum doesn't match amount", context);
      return;
    }

    if (_amountController.text.isEmpty || _nameController.text.isEmpty) {
      _errorPopup("Please fill in the required fields", context);
      return;
    }

    final group = context.read<GroupProvider>();
    final bill = context.read<BillProvider>();

    final Map<String, double> owes = {};

    for (var participant in _participants.entries) {
      owes[participant.key.id] = double.tryParse(participant.value.text) ?? 0;
    }

    setState(() {
      _isLoading = true;
    });

    final response = _isEditing
        ? (await bill.editBill(widget.bill!.id, _nameController.text,
            double.tryParse(_amountController.text) ?? 0, owes))
        : (await bill.createBill(_nameController.text,
            double.tryParse(_amountController.text) ?? 0, owes,
            groupId: widget.group?.id));

    if (response != null) {
      if (!mounted) return;
      _errorPopup(response, context);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (widget.group != null) {
      await group.fetchGroup(widget.group!.id);
    }
    setState(() {
      _isLoading = false;
    });
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>();
    final currentUser = user.currentUser;

    if (!_participants.containsKey(currentUser) && !_isEditing) {
      _participants[currentUser!] = TextEditingController(text: "0");
    }

    return Scaffold(
        appBar: AppBar(
          title:
              _isEditing ? const Text('Edit Bill') : const Text('Create Bill'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Inputs
                WhitePaddedContainer(
                    child: Column(
                  children: [
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
                  ],
                )),

                WhitePaddedContainer(
                    child: Column(
                  children: [
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
                          onPressed: _splitEqually,
                          child: const Text("Split"),
                        )
                      ],
                    ),
                    for (final participant in _participants.entries)
                      Row(
                        children: [
                          UserDispaly(user: participant.key),
                          const Spacer(),
                          if (_isPercentage) ...[
                            SizedBox(
                              width: 45,
                              child: TextField(
                                controller: participant.value,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                onChanged: (_) => _reCalculate(),
                              ),
                            ),
                            const Text("%"),
                            const SizedBox(width: 20)
                          ],
                          const Text("₹"),
                          SizedBox(
                            width: 70,
                            child: _isPercentage
                                ? Text(
                                    _valueFromPercentage(participant.value,
                                        round: true),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )
                                : TextField(
                                    controller: participant.value,
                                    onChanged: (_) => _reCalculate(),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                  ),
                          )
                        ],
                      ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          _isPercentage
                              ? "Total: ${_sum().toStringAsFixed(2)}%"
                              : "Total: ₹${_sum().toStringAsFixed(2)}",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                                color:
                                    _isValid() ? Palette.alpha : Palette.beta,
                              ),
                        ),
                      ),
                    ),
                  ],
                )),

                const SizedBox(height: 20),

                _isLoading
                    ? const SpinKitPulse(
                        color: Palette.alpha,
                      )
                    : MediumButton(
                        text: _isEditing ? "Save" : "Create",
                        color: Palette.alpha,
                        callback: () => _createOrSave(context),
                        icon: _isEditing ? Icons.save : Icons.add,
                      )
              ],
            ),
          ),
        ));
  }
}
