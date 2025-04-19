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
      // final newval = Product(
      //     name: 'Shirinlik 1',
      //     description:
      //         "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
      //     price: 100.0,
      //     id: '1212',
      //     imageUrl:
      //         "https://png.pngtree.com/png-vector/20231019/ourmid/pngtree-traditional-indian-mithai-png-image_10212114.png",
      //     categorie: "Tort");
      // if (!_products.any((product) => product.id == newval.id)) {
      //   // Agar mahsulot ro'yxatda mavjud bo'lmasa, uni qo'shish
      //   _products.add(newval);
      // }

      } catch (e) {
      throw Exception('Error fetching products: $e');
    }finally{
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
      await FirebaseFirestore.instance.collection('products').doc(product.id).set(product.toJson());
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
      await FirebaseFirestore.instance.collection('products').doc(product.id).update(product.toJson());
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
