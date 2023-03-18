import 'package:sp_frontend/group/group_modal.dart';
import 'package:sp_frontend/user/user_modal.dart';

class BaseBill {
  final String id;
  final String title;
  final double amount;
  final bool isCreditor;

  BaseBill(this.id, this.title, this.amount, this.isCreditor);

  factory BaseBill.fromJson(Map json, bool isCreditor) {
    return BaseBill(
      json['id'],
      json['title'],
      json['amount'].toDouble(),
      isCreditor,
    );
  }
}

class Bill extends BaseBill {
  final BaseUser creditor;
  final List<Owe> owes;

  Bill(String id, String title, double amount, bool isCreditor, this.owes,
      this.creditor)
      : super(id, title, amount, isCreditor);

  factory Bill.fromJsonAndGroup(Map json, BaseGroup group) {
    final baseGroup = BaseBill.fromJson(json, false);
    final creditor = group.getUser(json['creditorId']);

    List<Owe> owes = [];

    for (var owe in json['owes']) {
      owes.add(Owe.fromJsonAndGroup(owe, group));
    }

    return Bill(
      baseGroup.id,
      baseGroup.title,
      baseGroup.amount,
      baseGroup.isCreditor,
      owes,
      creditor,
    );
  }

  factory Bill.fromJson(Map json) {
    final baseGroup = BaseBill.fromJson(json, false);
    final creditor = BaseUser.fromJson(json['creditor']);

    List<Owe> owes = [];

    for (var owe in json['owes']) {
      owes.add(Owe.fromJson(owe));
    }

    return Bill(
      baseGroup.id,
      baseGroup.title,
      baseGroup.amount,
      baseGroup.isCreditor,
      owes,
      creditor,
    );
  }
}

class Owe {
  final String id;
  final double amount;
  final OweStatus status;
  final BaseUser debtor;

  Owe(this.id, this.amount, this.status, this.debtor);

  factory Owe.fromJsonAndGroup(Map json, BaseGroup group) {
    return Owe(
      json['id'],
      json['amount'].toDouble(),
      json['status'] == 'PENDING' ? OweStatus.pending : OweStatus.paid,
      group.getUser(json['debtorId']),
    );
  }
  factory Owe.fromJson(Map json) {
    return Owe(
      json['id'],
      json['amount'].toDouble(),
      json['status'] == 'PENDING' ? OweStatus.pending : OweStatus.paid,
      BaseUser.fromJson(json['debtor']),
    );
  }
}

enum OweStatus { pending, paid }
