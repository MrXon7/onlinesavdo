import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_savdo/core/constants/colors.dart';
import 'package:online_savdo/data/models/product_model.dart';
import 'package:online_savdo/presentation/pages/admin_pages/editProductScreen.dart';
import 'package:online_savdo/presentation/providers/product_provider.dart';
import 'package:provider/provider.dart';

class Adm_product_cart extends StatelessWidget {
  Adm_product_cart({
    super.key,
    required this.products,
  });
 final List<Product> products;
 

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (_, index) {
        final product = products[index];
        return Column(
          children: [
            Container(
              color: SweetShopColors.cardBackground,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: EdgeInsets.all(2),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: SweetShopColors.cakeColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, StackTrace) =>
                              Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${product.price.toStringAsFixed(2)} so'm",
                          style: GoogleFonts.inter(color: Colors.blue),
                        )
                      ],
                    )),
                    Row(
                      children: [
                        IconButton(
                            icon: Icon(Icons.edit,
                                color: SweetShopColors.accent),
                            onPressed: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          EditProductScreen(product: product,)));
                            }),
                        IconButton(
                            icon: Icon(Icons.delete,
                                color: SweetShopColors.error),
                            onPressed: () async {
                              try {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("O'chirish"),
                                      content: Text(
                                          "Siz ushbu mahsulotni o'chirmoqchimisiz?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Yo'q")),
                                        TextButton(
                                            onPressed: () {
                                              Provider.of<ProductProvider>(context, listen: false)
                                              .deleteProduct(product.id);
                                              Navigator.of(context).popUntil((route) => route.isFirst);
                                            },
                                            child: Text("Ha")),
                                      ],
                                    );
                                  },
                                );
                                
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Text(
                                  "Error deleting product: $e",
                                  textAlign: TextAlign.center,
                                )));
                              }
                            }),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey[300],
              thickness: 1,
            )
          ],
        );
      },
    );
  }
}
