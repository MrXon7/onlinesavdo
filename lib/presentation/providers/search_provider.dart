import 'package:flutter/material.dart';
import 'package:online_savdo/data/models/product_model.dart';
import 'package:online_savdo/presentation/providers/product_provider.dart';
import 'package:provider/provider.dart';

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
  Future<void> searchProducts(BuildContext context, String query) async {
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
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      
      // So'rovga moslarini filtirlami
      _searchResaults=productProvider.products.where((product)=>
        product.name.toLowerCase().contains(query.toLowerCase()) ||
        product.description.toLowerCase().contains(query.toLowerCase()) ||
        product.categorie.toLowerCase().contains(query.toLowerCase())
      ).toList(); 
      
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
