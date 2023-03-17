import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sp_frontend/components/user_display.dart';
import 'package:sp_frontend/group/group_modal.dart';
import 'package:sp_frontend/user/user_modal.dart';
import 'package:sp_frontend/user/user_provider.dart';

class AddFromGroup extends StatefulWidget {
  final Group group;
  final List<BaseUser> users;
  const AddFromGroup({super.key, required this.group, required this.users});

  @override
  State<AddFromGroup> createState() => _AddFromGroupState();
}

class _AddFromGroupState extends State<AddFromGroup> {
  void _toggleUser(bool v, BaseUser user) {
    {
      setState(() {
        if (v) {
          widget.users.add(user);
        } else {
          widget.users.removeWhere((element) => element.id == user.id);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Set<String> selected = widget.users.map((e) => e.id).toSet();
    final currentUser = context.read<UserProvider>().currentUser;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Wrap(children: [
        for (final user in widget.group.users.entries)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
              label: UserDispaly(user: user.value),
              selected: selected.contains(user.value.id),
              onSelected: user.value.id == currentUser!.id
                  ? null
                  : (v) => _toggleUser(v, user.value),
            ),
          )
      ]),
    );
  }
}
