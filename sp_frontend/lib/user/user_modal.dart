import 'package:sp_frontend/bill/bill_modal.dart';
import 'package:sp_frontend/group/group_modal.dart';

class BaseUser {
  final String id;
  final String userId;
  final String name;

  BaseUser(this.id, this.userId, this.name);

  factory BaseUser.fromJson(Map json) {
    return BaseUser(
      json['id'],
      json['userId'],
      json['name'],
    );
  }
}

class User extends BaseUser {
  final String email;
  final List<BaseGroup> groups;
  final List<BaseBill> bills;

  User(String id, String userId, String name, this.email, this.groups,
      this.bills)
      : super(id, userId, name);

  factory User.fromJson(Map json) {
    final List<BaseBill> bills =
        (json['bills'] as List).map((e) => BaseBill.fromJson(e, true)).toList();

    for (var owe in json["owes"]) {
      bills.add(BaseBill.fromJson(owe["bill"], false));
    }

    return User(
      json['id'],
      json['userId'],
      json['name'],
      json['email'],
      (json['groups'] as List).map((e) => BaseGroup.fromJson(e)).toList(),
      bills,
    );
  }
}
