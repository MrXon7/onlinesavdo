import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_savdo/presentation/providers/cart_provider.dart';
import 'package:online_savdo/presentation/widgets/cart_item_card.dart';
import 'package:online_savdo/presentation/widgets/checkout_section.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Savatcha",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold, // Maximum qalinlik
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            Expanded(
                child: Consumer<CartProvider>(builder: (context, cart, child) {
              if (cart.items.isEmpty) {
                return const Center(
                  child: Text("Savatcha bo'sh"),
                );
              }
              return ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, i) => CartItemCard(
                        cartItem: cart.items[i],isOrdered: false,
                      ));
            })),
            //checkoutSection
            CheckoutSection()
          ],
        ),
      ),
    );
  }
}
