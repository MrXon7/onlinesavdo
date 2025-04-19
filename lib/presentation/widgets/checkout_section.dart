import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_savdo/core/constants/colors.dart';
import 'package:online_savdo/presentation/pages/checkout_page.dart';
import 'package:online_savdo/presentation/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CheckoutSection extends StatelessWidget {
  const CheckoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
        ),
      ),
      child: Consumer<CartProvider>(builder: (context, cart, child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Jami:", style: GoogleFonts.inter()),
                Text(
                  "${cart.totalAmount.toStringAsFixed(2)} so'm",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: cart.items.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckoutPage()));
                        // xarid qilish sahifasiga o'tish
                      },
                style: ElevatedButton.styleFrom(
                    backgroundColor: SweetShopColors.accent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: Text(
                  "Xarid qilish",
                  style: GoogleFonts.inter(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
