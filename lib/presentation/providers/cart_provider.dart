import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_savdo/data/models/product_model.dart';

class CartItem {
  final String id;
  final Product product;
  int quantity; //cartdagi bitta item soni

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      // Replace these fields with the actual fields in your CartItem class
      id: json['id'],
      product: json['product'],
      quantity: json['quantity'],
    );
  }
}

class CartProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CartItem> _items = [];
  int _quantity = 0;
  int get quantity => _quantity;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<CartItem> get items => [..._items];
  double get totalAmount {
    return _items.fold(0, (sum, item) {
      return sum + (item.product.price * item.quantity);
    });
  }

  Future<void> fetchCartItems(String userId) async {
    // Fetch cart items from the database or API
    // and update _items list accordingly
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(userId).get();

      if (snapshot.exists) {
        _items = (snapshot['cartItems'] as List<dynamic>).map((item) {
          return CartItem(
            id: item['id'],
            product: Product(
              id: item['product']['id'],
              name: item['product']['name'],
              price: item['product']['price'],
              description: item['product']['description'],
              imageUrl: item['product']['imageUrl'],
              categorie: item['product']['categorie'],
            ),
            quantity: item['quantity'],
          );
        }).toList();
      }
    } catch (error) {
      // Handle error
      print("Error fetching cart items: $error");
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateFirebase(String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .update({"cartItems": _items.map((item) => item.toJson()).toList()});
  }

  Future<void> addItem(Product product, String userId) async {
    _isLoading = true;
    notifyListeners();
    final existingIndex = //Savatchada bu indexdagi maxsulot bor yo'qligini aniqlash
        _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++; //bor bo'lsa ustiga qo'shish
    } else {
      //bo'lmasa yangi qo'shish
      _items.add(CartItem(
        id: DateTime.now().toString(),
        product: product,
        quantity: 1,
      ));
    }
    // firebasega  qo'shish
    await updateFirebase(userId);
    _isLoading = false;
    notifyListeners();
  }

  int getProductQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      return _items[index].quantity;
    }
    return 0; // Agar mahsulot topilmasa, 0 qaytaradi
  }

  bool shouldShowCartButton(String productId) {
    return getProductQuantity(
        productId)>0; // Agar mahsulot savatchada bo'lsa, tugmani ko'rsatadi
  }

  // o'chirish
  void removeItem(String productId, String userId) async {
    _items.removeWhere((item) => item.product.id == productId);
    _firestore.collection('users').doc(userId).update({'cartItems': _items});
    notifyListeners();
  }

  // cartni tozalash
  void clearCart(String userId) async {
    _items = [];
    updateFirebase(userId);
    notifyListeners();
  }

  // cartda qiymatni  oshirish
  void increaseQuantity(String productId, String userId) async {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
      await updateFirebase(userId);
    }
  }

  // cartda qiymatni pasaytirish
  void decreaseQuantity(String productId, String userId) async {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
      await updateFirebase(userId);
    }
  }
}
