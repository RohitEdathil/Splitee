import 'package:flutter/material.dart';
import 'package:sp_frontend/group/group_modal.dart';
import 'package:sp_frontend/theme/colors.dart';

class GroupCard extends StatelessWidget {
  final BaseGroup group;
  const GroupCard({super.key, required this.group});

  String groupMembers() {
    String members = '';
    for (final member in group.users) {
      members += '${member.name} • ';
    }
    return members.substring(0, members.length - 2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 250,
                child: Text(
                  group.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: Palette.betaDark,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    width: 250,
                    child: Text(groupMembers(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(color: Palette.betaDark)),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.arrow_forward_ios, color: Palette.betaDark, size: 15),
        ],
      ),
    );
  }
}
