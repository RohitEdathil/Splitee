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
