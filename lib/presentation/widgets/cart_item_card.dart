import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_savdo/core/constants/colors.dart';
import 'package:online_savdo/presentation/pages/productDetail_page.dart';
import 'package:online_savdo/presentation/providers/auth_provider.dart';
import 'package:online_savdo/presentation/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final bool isOrdered;
  const CartItemCard(
      {super.key, required this.cartItem, required this.isOrdered});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.userData;
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetailPage(
                    product: cartItem.product,
                    isAdmin: false,
                  ))),
      child: Container(
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
                    cartItem.product.image.url,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, StackTrace) => Container(
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
                    cartItem.product.name,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${cartItem.product.price.toStringAsFixed(2)} so'm",
                    style: GoogleFonts.inter(color: Colors.blue),
                  )
                ],
              )),
              isOrdered
                  ? Text(
                      "${cartItem.quantity} ta",
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    )
                  : Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Provider.of<CartProvider>(context, listen: false)
                                  .decreaseQuantity(
                                      cartItem.product.id, user!.id);
                            },
                            icon: const Icon(Icons.remove)),
                        Text(
                          cartItem.quantity.toString(),
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            onPressed: () {
                              Provider.of<CartProvider>(context, listen: false)
                                  .increaseQuantity(
                                      cartItem.product.id, user!.id);
                            },
                            icon: const Icon(Icons.add)),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
