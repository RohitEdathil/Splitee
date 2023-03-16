import 'package:sp_frontend/bill/bill_modal.dart';
import 'package:sp_frontend/user/user_modal.dart';

class BaseGroup {
  final String name;
  final String id;
  final Map<String, BaseUser> users;

  BaseGroup(this.name, this.id, this.users);

  factory BaseGroup.fromJson(Map json) {
    Map<String, BaseUser> users = {};

    for (var user in json['users']) {
      users[user['id']] = BaseUser.fromJson(user);
    }

    return BaseGroup(
      json['name'],
      json['id'],
      users,
    );
  }

  BaseUser getUser(String id) {
    return users[id]!;
  }
}

class Group extends BaseGroup {
  final List<Bill> bills;

  Group(String name, String id, Map<String, BaseUser> users, this.bills)
      : super(name, id, users);

  factory Group.fromJson(Map json) {
    final BaseGroup baseGroup = BaseGroup.fromJson(json);

    List<Bill> bills = [];

    for (var bill in json['bills']) {
      bills.add(Bill.fromJson(bill, baseGroup));
    }

    return Group(
      baseGroup.name,
      baseGroup.id,
      baseGroup.users,
      bills,
    );
  }
}
