import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_savdo/data/models/product_model.dart';


class ProductProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? userId;
  List<Product> _products = [];
  bool _isLoading = false;

  ProductProvider({this.userId});
  List<Product> get products => [..._products];
  bool get isLoading => _isLoading;

  Future<void> fetchPrducts() async {
    try {
      // Firebase Firestore dan ma'lumotlarni olish
      _isLoading = true;
      notifyListeners();
      final snapshot = await _firestore.collection('products').get();
      _products = snapshot.docs.map((doc) {
        return Product.fromJson(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(
    Product product,
    /*File imageFile8*/
  ) async {
    try {
      _isLoading = true;
      await FirebaseFirestore.instance
          .collection('products')
          .doc(product.id)
          .set(product.toJson());
      _products.add(product);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }

  Future<void> updateProduct(
    Product product,
    /*File imageFile*/
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(product.id)
          .update(product.toJson());
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(id).delete();
      _products.removeWhere((product) => product.id == id);
      notifyListeners();
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }

  Product findById(String id) {
    return _products.firstWhere((product) => product.id == id,
        orElse: () => throw Exception('Product not found'));
  }


}
