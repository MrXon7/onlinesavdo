import 'package:flutter/material.dart';
import 'package:online_savdo/data/models/order_model.dart';
import 'package:online_savdo/data/models/user_model.dart';
import 'package:online_savdo/presentation/providers/cart_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderProvider with ChangeNotifier {
  List<MyOrder> _orders = [];

  List<MyOrder> get orders => [..._orders];

  List<MyOrder> get pendingingOrders =>
      _orders.where((order) => order.status == OrderStatus.pending)
      .toList();
  List<MyOrder> get proccessingOrders => 
  _orders.where((order) => order.status == OrderStatus.processing)
      .toList(); // Jarayonda
  List<MyOrder> get shippedOrders => _orders
      .where((order) => order.status == OrderStatus.shipped)
      .toList(); // Yetkazilmoqda
  List<MyOrder> get delivredOrders => _orders
      .where((order) => order.status == OrderStatus.delivred)
      .toList(); // Yetkazib berilgan
  List<MyOrder> get cancelledOrders => _orders
      .where((order) => order.status == OrderStatus.cancelled)
      .toList(); // Bekor qilindi

  // Barcha buyurtmalarni yuklash
  Future<void> fetchAllOrders() async {
    // API dan buyurtmalarni yuklash
    try {
      final doc = await FirebaseFirestore.instance.collection('orders').get();
      _orders = doc.docs
          .map((orderDoc) => MyOrder.fromMap(orderDoc.data()))
          .toList();
      notifyListeners();
    } catch (e) {
      print("Errorim mening: $e");
    }
    notifyListeners();
  }

  Future<void> fetchOrders(String userId) async {
    // API dan buyurtmalarni yuklash
    try {
      final doc = await FirebaseFirestore.instance.collection('orders').get();
      _orders = doc.docs
          .where((orderDoc) => orderDoc.data()['customer']['id'] == userId)
          .map((orderDoc) => MyOrder.fromMap(orderDoc.data()))
          .toList();
      notifyListeners();
    } catch (e) {
      print("Errorim mening: $e");
    }
    notifyListeners();
  }

// Buyurtma berish
  Future<void> placeOrder({
    required List<CartItem> items,
    required double totalAmount,
    required User customer,
    required String paymentMethod,
    required String istak,
  }) async {
    final newOrder = MyOrder(
      id: "ORD-${DateTime.now().millisecondsSinceEpoch}",
      orderDate: DateTime.now(),
      items: items
          .map((cartItem) => OrderItem(
                product: cartItem.product,
                quantity: cartItem.quantity,
                price: cartItem.product.price,
              ))
          .toList(),
      totalAmount: totalAmount,
      status: OrderStatus.pending,
      customer: {
        'id': customer.id,
        'name': customer.name,
        'phone': customer.phone,
        'address': customer.address,
      },
      paymentMethod: paymentMethod,
      istak: istak,
    );
    _orders.add(newOrder);

    notifyListeners();
    // BU yerda API ga buyurtmani yuborish logikasi bo'ladi
    await FirebaseFirestore.instance.collection('orders').doc(newOrder.id).set({
      'id': newOrder.id,
      'orderDate': newOrder.orderDate,
      'items': newOrder.items
          .map((item) => {
                'product': item.product.toJson(),
                'quantity': item.quantity,
                'price': item.price,
              })
          .toList(),
      'totalAmount': newOrder.totalAmount,
      'status': newOrder.status.toString(),
      'customer': {
        'id': customer.id,
        'name': customer.name,
        'phone': customer.phone,
        'address': customer.address,
      },
      'paymentMethod': paymentMethod,
      'istak': istak,
    });
  }

  // Buyurtma holatini yangilash
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
// buyerda bo'ladi: API ga buyurtma holatini yangilash
      // misol uchun buyurtma holatini yangilash
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index >= 0) {
        if (status == OrderStatus.cancelled) {
          _orders.removeAt(index);
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(orderId)
              .delete();
              notifyListeners();
        }else{
          _orders[index] = _orders[index].copyWith(status: status);
            await FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .update(_orders[index].toMap());
        
        notifyListeners();
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
