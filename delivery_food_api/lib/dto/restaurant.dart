import 'money.dart';
import 'menu_item.dart';

class Restaurant {
  final String status;
  final String deliveryTime;
  final Money? deliveryCost;
  final Money? maxOrderAmount;
  final String workingHours;
  final List<MenuItem> menu;

  Restaurant({
    required this.status,
    required this.deliveryTime,
    this.deliveryCost,
    this.maxOrderAmount,
    required this.workingHours,
    required this.menu,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    status: json['status'],
    deliveryTime: json['deliveryTime'],
    deliveryCost: json['deliveryCost'],
    maxOrderAmount: json['maxOrderAmount'],
    workingHours: json['workingHours'],
    menu: json['menu'],
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'deliveryTime': deliveryTime,
    'deliveryCost': deliveryCost,
    'maxOrderAmount': maxOrderAmount,
    'workingHours': workingHours,
    'menu': menu,
  };
}
