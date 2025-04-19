import 'package:online_savdo/data/models/product_model.dart';
import 'package:online_savdo/presentation/providers/cart_provider.dart';

class User {
  final String id;
  final String name;
  final String phone;
  final String address;
  final List<CartItem> cartItems;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.cartItems,
  });

  // JSON dan modelga o'tish
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      cartItems: json['cartItems']
          .map<CartItem>((item) => CartItem(
                id: item['id'],
                product: Product.fromJson(item['product']),
                quantity: item['quantity'],
              ))
          .toList()
    );
  }


   // Modeldan JSON ga o'tish
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'cartItems': cartItems,
    };
  }
}
