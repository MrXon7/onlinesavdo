import 'package:flutter/material.dart';
import 'package:online_savdo/data/models/product_model.dart';

class SearchProvider with ChangeNotifier {
  // final ProductRepository _productRepository;

  // SearchProvider(this._productRepository)

  List<Product> _searchResaults = [];
  bool _isSearching = false;
  String _searchQurey = '';
  String _errorMessage = '';

  // getterlar
  List<Product> get searchResaults => _searchResaults;
  bool get isSearching => _isSearching;
  String get searchQuery => _searchQurey;
  String get errorMessage => _errorMessage;

  // Mahsulotni qidirish metodi
  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      _searchResaults = [];
      _searchQurey = '';
      notifyListeners();
      return;
    }
    _searchQurey = query;
    _isSearching = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Barcha mahsulotlarni olish
      // final allProducts =
      //     []; // final allProducts = await _productRepository.getAllProducts();

      // So'rovga moslarini filtirlami
    } catch (e) {
      _errorMessage = "Qidiruvda xatolik${e.toString()}";
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  // qidiruvni tozalash
  void clearSearch() {
    _searchResaults = [];
    _searchQurey = '';
    _errorMessage = '';
    notifyListeners();
  }
}
