import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_savdo/data/models/product_model.dart';

enum OrderStatus {
  pending, // kutilyapti
  processing, //jarayonda
  shipped, //yetkazilmoqda
  delivred, //yetkazib berilgan
  cancelled //Bekor qilindi
}

class MyOrder {
  final String id;
  final DateTime orderDate;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;
  final Map<String,dynamic> customer;
  final String paymentMethod;
  final String istak;

  MyOrder({
    required this.id,
    required this.orderDate,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.customer,
    required this.paymentMethod,
    required this.istak,
  });

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Kutilmoqda';
      case OrderStatus.processing:
        return 'Jarayonda';
      case OrderStatus.shipped:
        return 'Yetkazilmoqda';
      case OrderStatus.delivred:
        return 'Yetkazib berildi';
      case OrderStatus.cancelled:
        return 'Bekor qilindi';
    }
  }

  Color get statusColor {
    switch (status) {
      case OrderStatus.pending:
        return colors.grey;
      case OrderStatus.processing:
        return colors.orange;
      case OrderStatus.shipped:
        return colors.blue;
      case OrderStatus.delivred:
        return colors.green;
      case OrderStatus.cancelled:
        return colors.red;
    }
  }

  MyOrder copyWith({
    String? id,
    DateTime? orderDate,
    List<OrderItem>? items,
    double? totalAmount,
    OrderStatus? status,
    Map<String,dynamic>? customer,
    String? paymentMethod,
    String? istak,
  }) {
    return MyOrder(
        id: id ?? this.id,
        orderDate: orderDate ?? this.orderDate,
        items: items ?? this.items,
        totalAmount: totalAmount ?? this.totalAmount,
        status: status ?? this.status,
        customer: customer ?? this.customer,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        istak: istak ?? this.istak,
        );
  }

// Convert MyOrder to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderDate': orderDate.toIso8601String(),
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status.toString(),
      'customer': customer,
      'paymentMethod': paymentMethod,
      'istak': istak,
    };
  }

  // Add the fromMap factory constructor
  factory MyOrder.fromMap(Map<String, dynamic> map) {
    return MyOrder(
      id: map['id'] as String,
      orderDate: (map['orderDate'] as Timestamp).toDate(),
      items: (map['items'] as List<dynamic>)
          .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      totalAmount: map['totalAmount'] as double,
      status: OrderStatus.values.firstWhere(
          (status) => status.toString() == map['status']),
    customer: {
      'id': map['customer']['id'] as String,
      'name': map['customer']['name'] as String,
      'phone': map['customer']['phone'] as String,
      'address': map['customer']['address'] as String,
    },
      paymentMethod: map['paymentMethod'] as String,
      istak: map['istak'] as String,
      
    );
  }

}

class OrderItem {
  final Product product;
  final int quantity;
  final double price;

  OrderItem({
    required this.product,
    required this.quantity,
    required this.price,
  });

  // Add the fromMap factory constructor
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      product: Product.fromJson(map['product'] as Map<String, dynamic>),
      quantity: map['quantity'] as int,
      price: map['price'] as double,
    );
  }

  // Convert OrderItem to a map
  Map<String, dynamic> toMap() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'price': price,
    };
  }
}

class colors {
   static const Color grey = Color(0xFF808080); // Example hex color for grey
  static const Color orange = Color(0xFFFFA500); // Example hex color for orange
  static const Color blue = Color(0xFF0000FF); // Example hex color for blue
  static const Color green = Color(0xFF008000); // Example hex color for green
  static const Color red = Color(0xFFFF0000); // Example hex color for red
  static const Color black = Color(0xFF000000); // Example hex color for black
  static const Color white = Color(0xFFFFFFFF); // Example hex color for white
}
