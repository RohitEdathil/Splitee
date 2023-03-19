import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sp_frontend/components/custom_input.dart';
import 'package:sp_frontend/components/user_display.dart';
import 'package:sp_frontend/components/white_padded_container.dart';
import 'package:sp_frontend/theme/colors.dart';
import 'package:sp_frontend/user/user_modal.dart';
import 'package:sp_frontend/user/user_provider.dart';

class AddWithoutGroup extends StatefulWidget {
  final List<BaseUser> users;
  const AddWithoutGroup({super.key, required this.users});

  @override
  State<AddWithoutGroup> createState() => _AddWithoutGroupState();
}

class _AddWithoutGroupState extends State<AddWithoutGroup> {
  final controller = TextEditingController();

  List<BaseUser> results = [];

  // Fast lookup set
  final Set<String> _userIds = {};

  @override
  void initState() {
    super.initState();

    _userIds.addAll(widget.users.map((e) => e.id));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Initiates search
  void _search() async {
    final users = await context.read<UserProvider>().search(controller.text);

    if (!mounted) return;
    setState(() {
      results = users;
    });
  }

  void _addUser(BaseUser user) {
    setState(() {
      widget.users.add(user);
      _userIds.add(user.id);
    });
  }

  void _removeUser(BaseUser user) {
    setState(() {
      widget.users.remove(user);
      _userIds.remove(user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<UserProvider>().currentUser!;
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              // Selected users
              Padding(
                padding: const EdgeInsets.only(top: 85.0),
                child: Column(
                  children: [
                    for (final user in widget.users)
                      // One selected user
                      Row(
                        children: [
                          IconButton(
                              onPressed: currentUser == user
                                  ? null
                                  : () => _removeUser(user),
                              key: ValueKey(user.id),
                              icon: const Icon(Icons.delete_outline)),
                          UserDispaly(user: user),
                        ],
                      ),
                  ],
                ),
              ),
              // Search layer
              Column(
                children: [
                  // Search bar
                  CustomInput(
                    controller: controller,
                    hintText: "Search by user id",
                    color: Colors.white,
                    onChanged: (_) => _search(),
                  ),

                  // Results display
                  if (results.isNotEmpty)
                    WhitePaddedContainer(
                        child: Column(children: [
                      // Search results
                      for (final user in results)
                        // Search result
                        Row(
                          children: [
                            IconButton(
                                color: Palette.alpha,
                                onPressed: _userIds.contains(user.id) ||
                                        currentUser == user
                                    ? null
                                    : () => _addUser(user),
                                icon: const Icon(Icons.add)),
                            UserDispaly(user: user),
                          ],
                        ),
                      // Close button
                      TextButton.icon(
                          label: const Text("Close"),
                          onPressed: () => setState(() => results = []),
                          icon: const Icon(Icons.close)),
                    ])),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
