import 'package:sp_frontend/user/user_modal.dart';

class BaseGroup {
  final String name;
  final String id;
  final List<BaseUser> users;

  BaseGroup(this.name, this.id, this.users);

  factory BaseGroup.fromJson(Map<String, dynamic> json) {
    return BaseGroup(
      json['name'],
      json['id'],
      (json['users'] as List).map((e) => BaseUser.fromJson(e)).toList(),
    );
  }
}
