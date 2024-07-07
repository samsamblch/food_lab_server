class User {
  final String address;

  User({
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    address: json['address'],
  );

  Map<String, dynamic> toJson() => {
    'address': address,
  };
}
