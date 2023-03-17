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
  final List<Payment> payments = [];
  late final List<MapEntry<BaseUser, double>> sortedBalances;

  Group(String name, String id, Map<String, BaseUser> users, this.bills)
      : super(name, id, users) {
    Map<BaseUser, double> balances = {};

    for (final bill in bills) {
      for (final owe in bill.owes) {
        if (owe.status == OweStatus.paid) continue;

        balances.update(owe.debtor, (value) => value - owe.amount,
            ifAbsent: () => -owe.amount);

        balances.update(bill.creditor, (value) => value + owe.amount,
            ifAbsent: () => owe.amount);

        payments.add(Payment(owe.debtor, bill.creditor, owe.amount));
      }
    }

    sortedBalances = balances.entries.toList();
    sortedBalances.sort((a, b) => -a.value.compareTo(b.value));
  }

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

class Payment {
  final BaseUser from;
  final BaseUser to;
  final double amount;

  Payment(this.from, this.to, this.amount);
}
