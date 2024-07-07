import 'money.dart';

class MenuItem {
  final int id;
  final String name;
  final Money price;
  final int count;
  final String? imageUrl;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.count,
    this.imageUrl,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
    id: json['id'],
    name: json['name'],
    price: json['price'],
    count: json['count'],
    imageUrl: json['imageUrl'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'count': count,
    'imageUrl': imageUrl,
  };
}
