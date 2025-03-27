class Transaction {
  final String title;
  final String subtitle;
  final String time;
  final String amount;
  final String currency;
  final String icon;

  Transaction({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.amount,
    required this.currency,
    required this.icon,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      title: json['title'],
      subtitle: json['subtitle'],
      time: json['time'],
      amount: json['amount'],
      currency: json['currency'],
      icon: json['icon'],
    );
  }
}
