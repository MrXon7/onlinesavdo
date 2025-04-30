import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_savdo/data/models/order_model.dart';
import 'package:intl/intl.dart';
import 'package:online_savdo/presentation/pages/productDetail_page.dart';
import 'package:online_savdo/presentation/providers/order_provider.dart';
import 'package:provider/provider.dart';

class OrderCart extends StatelessWidget {
  final MyOrder order;
  const OrderCart({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Chip(
                  label: Text(
                    order.statusText,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      color: order.statusColor.computeLuminance() > 0.5
                          ? Color(0xFF000000)
                          : Color(
                              0xFFFFFFFF), // Replace with your desired color
                    ),
                  ),
                  backgroundColor: order.statusColor,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Buyurtma: #${order.id}",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "Sana: ${DateFormat('dd.MM.yyyy HH:mm').format(order.orderDate)}",
              style: GoogleFonts.inter(color: Colors.grey[600]),
            ),
            Text(
              "Jami: ${NumberFormat('#,###').format(order.totalAmount)} so'm",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            Text(
              'Yetkazish manzili: ${order.customer['address']}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              'To\'lov usuli: ${order.paymentMethod}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            const Text(
              'Mahsulotlar:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...order.items
                .map((item) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetailPage(
                                      product: item.product,
                                      isAdmin: false,
                                    )));
                      },
                      child: ListTile(
                        leading: Image.network(
                          item.product.image.url,
                          width: 50,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image),
                          ),
                        ),
                        title: Text(
                          item.product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(),
                        ),
                        subtitle: Text(
                          "${NumberFormat('#,###').format(item.price)} so'm",
                          style: GoogleFonts.inter(),
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${item.quantity} dona",
                                style: GoogleFonts.inter()),
                            const SizedBox(height: 4),
                            Text(
                              "${NumberFormat('#,###').format(item.price * item.quantity)} so'm",
                              style: GoogleFonts.inter(),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
            const SizedBox(height: 16),
            if (order.status == OrderStatus.pending)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    _showCancelDialog(context, order.id);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red),
                  ),
                  child: const Text(
                    'Buyurtmani bekor qilish',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buyurtmani bekor qilish'),
        content:
            const Text('Haqiqatan ham bu buyurtmani bekor qilmoqchimisiz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor qilish'),
          ),
          TextButton(
            onPressed: () async {
              final orderProvider =
                  Provider.of<OrderProvider>(context, listen: false);
              await orderProvider.updateOrderStatus(
                  orderId, OrderStatus.cancelled);
              Navigator.pop(context);
            },
            child: const Text('Ha, bekor qilish',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
