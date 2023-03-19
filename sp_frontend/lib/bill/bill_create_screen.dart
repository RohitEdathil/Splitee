import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sp_frontend/bill/bill_modal.dart';
import 'package:sp_frontend/bill/bill_provider.dart';
import 'package:sp_frontend/bill/components/add_from_group.dart';
import 'package:sp_frontend/bill/components/add_without_group.dart';
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

/// Creates / Edits a bill
///
/// If [group] is null, the bill is created without a group
///
/// If [bill] is null, works in create mode else edit mode
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

    // Initialize the bill details in edit mode
    if (!_isEditing) return;
    _nameController.text = widget.bill!.title;
    _amountController.text = widget.bill!.amount.toString();
    for (var owe in widget.bill!.owes) {
      _participants[owe.debtor] =
          TextEditingController(text: owe.amount.toString());
    }
  }

  /// Toggles % and ₹
  void _setPercentage(bool value) {
    for (var participant in _participants.entries) {
      // Converts b/w % and ₹
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

  /// Splits the bill equally
  void _splitEqually() {
    // Ensures amount is present
    if (_amountController.text.isEmpty) return;

    // Reads amount in ₹ mode, 100 in % mode
    final amount =
        _isPercentage ? 100 : double.tryParse(_amountController.text) ?? 0;
    final count = _participants.length;

    // Splits by division
    for (var participant in _participants.entries) {
      participant.value.text = (amount / count).toString();
    }
    setState(() {});
  }

  void _editParticipants(BuildContext context) async {
    // Fetches current participants
    final currentParticipants = _participants.keys.toList();

    // Navigates to apporpriate AddWidget based on availability of group
    if (widget.group == null) {
      await showModalBottomSheet<List<BaseUser>>(
          context: context,
          enableDrag: true,
          // Fill
          isScrollControlled: true,
          builder: (_) => AddWithoutGroup(users: currentParticipants));
    } else {
      await showModalBottomSheet<List<BaseUser>>(
          context: context,
          builder: (_) =>
              AddFromGroup(group: widget.group!, users: currentParticipants));
    }

    // currentParticipants is modified in-place by the AddWidget

    for (final participant in currentParticipants) {
      // Doesn't change existing participants
      if (_participants.containsKey(participant)) continue;

      // Initializes new ones as 0
      _participants[participant] = TextEditingController(text: "0");
    }

    // Remove removed participants
    _participants.removeWhere(
        (participant, _) => !currentParticipants.contains(participant));

    setState(() {});
  }

  /// Converts to ₹ from % (can optionally round, for displaying ONLY!)
  String _valueFromPercentage(TextEditingController controller,
      {bool round = false}) {
    // 0.0 for empty
    if (_amountController.text.isEmpty) return "0.0";

    final perc = double.tryParse(controller.text);

    // 0 for null
    if (perc == null) {
      controller.text = "0";
      return "0";
    }

    // With rounding
    if (round) {
      return (perc * (double.tryParse(_amountController.text) ?? 0) / 100)
          .toStringAsFixed(2)
          .toString();
    }

    // Without rounding
    return (perc * (double.tryParse(_amountController.text) ?? 0) / 100)
        .toString();
  }

  /// Converts to % from ₹
  String _percentageFromValue(TextEditingController controller) {
    // 0.0 for empty
    if (_amountController.text.isEmpty) return "0.0";

    final value = double.tryParse(controller.text) ?? 0;

    return (value * 100 / (double.tryParse(_amountController.text) ?? 0))
        .toString();
  }

  /// Refresh for value changes
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

  /// Checks if sum is same as amount
  bool _isValid() => _isPercentage
      ? _sum() == 100.0
      : _sum().toStringAsFixed(2) ==
          double.tryParse(_amountController.text)?.toStringAsFixed(2);

  void _errorPopup(String message, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(customSnackBar(context, message));
  }

  void _createOrSave(BuildContext context) async {
    // Ensures validity
    if (!_isValid()) {
      _errorPopup("Sum doesn't match amount", context);
      return;
    }

    // Validation for text fields
    if (_amountController.text.isEmpty || _nameController.text.isEmpty) {
      _errorPopup("Please fill in the required fields", context);
      return;
    }

    final group = context.read<GroupProvider>();
    final bill = context.read<BillProvider>();
    final user = context.read<UserProvider>();

    final Map<String, double> owes = {};

    // Generates owes to be send to server
    for (var participant in _participants.entries) {
      owes[participant.key.id] = double.tryParse(_isPercentage
              ? _valueFromPercentage(participant.value)
              : participant.value.text) ??
          0;
    }

    setState(() {
      _isLoading = true;
    });

    final amount = double.tryParse(_amountController.text) ?? 0;

    // Edits/Create based on mode
    final response = _isEditing
        ? (await bill.editBill(
            widget.bill!.id, _nameController.text, amount, owes))
        : (await bill.createBill(_nameController.text, amount, owes,
            groupId: widget.group?.id));

    // Shows any errors
    if (response != null) {
      if (!mounted) return;
      _errorPopup(response, context);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Refreshes group if available, else refreshes user
    if (widget.group != null) {
      await group.fetchGroup(widget.group!.id);
    } else {
      await user.reload();

      // Refreshes bill when no group and is editing
      if (_isEditing) {
        await bill.getBill(widget.bill!.id, forceRefresh: true);
      }
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

    // Add user a participant if not already and creating a bill
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
                      onChanged: (_) => _reCalculate(),
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

                      // Each participant
                      Row(
                        children: [
                          UserDispaly(user: participant.key),
                          const Spacer(),

                          // Percentage mode additions
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

                          // Value is text field if not percentage mode
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

                    // Total
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

                // Create or save button
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
