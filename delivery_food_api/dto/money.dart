class Money {
  final double amount;
  final String currency;

  Money({
    required this.amount,
    required this.currency,
  });

  factory Money.fromJson(Map<String, dynamic> json) => Money(
    amount: json['amount'],
    currency: json['currency'],
  );

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'currency': currency,
  };
}
