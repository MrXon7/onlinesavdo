import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_savdo/core/constants/colors.dart';
import 'package:online_savdo/data/models/product_model.dart';
import 'package:online_savdo/presentation/pages/main_screen.dart';
import 'package:online_savdo/presentation/providers/auth_provider.dart';
import 'package:online_savdo/presentation/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final bool isAdmin;
  const ProductDetailPage(
      {super.key, required this.product, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).userData;
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          product.categorie,
          style: GoogleFonts.inter(
            color: SweetShopColors.textDark,
            fontWeight: FontWeight.bold, // Maximum qalinlik
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //product rasmi
            Container(
              decoration: BoxDecoration(
                  color: SweetShopColors.cakeColor,
                  borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                child: Image.network(
                  product.imageUrl,
                  height: 370,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 370,
                    width: double.infinity,
                    color: Colors.grey[400],
                    child: const Icon(Icons.image),
                  ),
                ),
              ),
            ),
            // Mahsulot narxi va nomi
            const SizedBox(height: 8),
            Text(
              "${product.price.toStringAsFixed(2)} so'm",
              style: GoogleFonts.inter(
                color: SweetShopColors.textDark,
                fontSize: 28.0,
                fontWeight: FontWeight.w900, // Maximum qalinlik
              ),
            ),
            Text(
              product.name,
              style: GoogleFonts.inter(
                color: SweetShopColors.textDark,
                fontSize: 20.0,
                fontWeight: FontWeight.bold, // Maximum qalinlik
              ),
            ),
            const SizedBox(height: 16),
            Text("Tavsif",
                style: GoogleFonts.inter(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Wrap(
              children: [
                Text(
                  product.description,
                  overflow: TextOverflow.clip,
                  style: GoogleFonts.inter(color: Colors.grey),
                )
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: !isAdmin
          ? Container(
              height: 70,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  if (cart.shouldShowCartButton(product.id))
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainScreen(
                                                initialIndex: 2,
                                              )),
                                      (route) => false);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: SweetShopColors.accent,
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.shopping_cart,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      " O'tish",
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                    ),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: SweetShopColors.accent,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        onPressed: () async {
                          // Savatchaga qo'shish

                          await Provider.of<CartProvider>(context,
                                  listen: false)
                              .addItem(product, user!.id);
                          // Xabar ko'rsatish
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("${product.name} savatchaga qo'shildi"),
                            duration: const Duration(seconds: 2),
                          ));
                        },
                        child: cart.isLoading
                            ? Center(
                                child: SizedBox(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ))
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_shopping_cart,
                                      color: Colors.white),
                                  const SizedBox(width: 2),
                                  Text(
                                    "Savatga qo'shish",
                                    style: GoogleFonts.inter(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
