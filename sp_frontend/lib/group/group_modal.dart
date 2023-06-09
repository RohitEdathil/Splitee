import 'package:sp_frontend/bill/bill_modal.dart';
import 'package:sp_frontend/user/user_modal.dart';

class BaseGroup {
  final String name;
  final String id;
  final Map<String, BaseUser> users;

  BaseGroup(this.name, this.id, this.users);

  factory BaseGroup.fromJson(Map json) {
    Map<String, BaseUser> users = {};

    if (json['users'] != null) {
      for (var user in json['users']) {
        users[user['id']] = BaseUser.fromJson(user);
      }
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
  final Map<String, Bill> bills;
  final List<Payment> payments = [];
  late final List<MapEntry<BaseUser, double>> sortedBalances;

  Group(String name, String id, Map<String, BaseUser> users, this.bills)
      : super(name, id, users) {
    Map<BaseUser, double> balances = {};

    // Initialize balances to 0
    for (final user in users.values) {
      balances[user] = 0;
    }

    for (final bill in bills.values) {
      for (final owe in bill.owes) {
        // Skip if already paid
        if (owe.status == OweStatus.paid) continue;

        // Update balances
        balances[owe.debtor] = balances[owe.debtor]! - owe.amount;
        balances[bill.creditor] = balances[bill.creditor]! + owe.amount;

        // Add payment
        payments.add(Payment(owe.debtor, bill.creditor, owe.amount));
      }
    }

    // Sort balances
    sortedBalances = balances.entries.toList();
    sortedBalances.sort((a, b) => -a.value.compareTo(b.value));
  }

  factory Group.fromJson(Map json) {
    final BaseGroup baseGroup = BaseGroup.fromJson(json);

    Map<String, Bill> bills = {};

    for (var bill in json['bills']) {
      bills[bill["id"]] = Bill.fromJsonAndGroup(bill, baseGroup);
    }

    return Group(
      baseGroup.name,
      baseGroup.id,
      baseGroup.users,
      bills,
    );
  }

  Bill getBill(String id) {
    return bills[id]!;
  }
}

class Payment {
  final BaseUser from;
  final BaseUser to;
  final double amount;

  Payment(this.from, this.to, this.amount);
}
