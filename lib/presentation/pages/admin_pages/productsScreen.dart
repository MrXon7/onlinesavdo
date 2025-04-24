import 'package:flutter/material.dart';
import 'package:online_savdo/core/constants/colors.dart';
import 'package:online_savdo/data/models/product_model.dart';
import 'package:online_savdo/presentation/pages/admin_pages/editProductScreen.dart';
import 'package:online_savdo/presentation/providers/product_provider.dart';
import 'package:online_savdo/presentation/widgets/adm_pruduct_cart.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false).fetchPrducts();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductProvider>(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: productData.isLoading? Center(child: CircularProgressIndicator(color: SweetShopColors.accent)): 
          Adm_product_cart(products: productData.products),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add product screen
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => EditProductScreen(product:Product(id: "", name: "", description: "", price: 0, imageUrl: "", categorie: "", discount: 0),)));
        },
        backgroundColor: SweetShopColors.error,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

