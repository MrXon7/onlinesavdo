import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_savdo/data/models/order_model.dart';
import 'package:intl/intl.dart';
import 'package:online_savdo/presentation/pages/productDetail_page.dart';
import 'package:online_savdo/presentation/providers/order_provider.dart';
import 'package:provider/provider.dart';

class AdmOrderCart extends StatelessWidget {
  final MyOrder order;
  const AdmOrderCart({super.key, required this.order});

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
                _buildStatusAction(
                  context,
                  order,
                ),
              ],
            ),
            SizedBox(height: 8),
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
            Row(
              children: [
                Text(
                  'Tel: ${order.customer['phone']}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(width: 8),
                Text(
                  'To\'lov usuli: ${order.paymentMethod}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            Text(
              'Foydalanuvchi istaklari: ${order.istak}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            const Text(
              'Mahsulotlar:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...order.items
                .map((item) => ListTile(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                    product: item.product,
                                    isAdmin: true,
                                  ))),
                      leading: Image.network(
                        item.product.imageUrl,
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image),
                        ),
                      ),
                      title: Text(
                        item.product.name,
                        style: GoogleFonts.inter(),
                      ),
                      subtitle: Text(
                        "${NumberFormat('#,###').format(item.price)} so'm",
                        style: GoogleFonts.inter(),
                      ),
                      trailing: Text(
                        "${NumberFormat('#,###').format(item.price * item.quantity)} so'm",
                        style: GoogleFonts.inter(),
                      ),
                    ))
                .toList(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusAction(BuildContext context, MyOrder order) {
    return Wrap(
      spacing: 4.0,
      runSpacing: 4,
      children: [
        // Buyurtmani qabul qilish
        if (order.status == OrderStatus.pending)
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  _updateStatus(context, order, OrderStatus.processing);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text(
                  "Qabul qilish",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: order.statusColor.computeLuminance() > 0.5
                        ? Color(0xFF000000)
                        : Color(0xFFFFFFFF),
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () =>
                    _updateStatus(context, order, OrderStatus.cancelled),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  "Rad etish",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

        // Buyurtmani jo'natish
        if (order.status == OrderStatus.processing)
          ElevatedButton(
            onPressed: () => _updateStatus(context, order, OrderStatus.shipped),
            style: ElevatedButton.styleFrom(
              backgroundColor: order.statusColor,
            ),
            child: Text(
              "Buyurtmani jo'natish",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: order.statusColor.computeLuminance() > 0.5
                    ? Color(0xFF000000)
                    : Color(0xFFFFFFFF),
              ),
            ),
          ),
        // Buyurtmani yetkazilganini tasdiqlash
        if (order.status == OrderStatus.shipped)
          ElevatedButton(
            onPressed: () =>
                _updateStatus(context, order, OrderStatus.delivred),
            style: ElevatedButton.styleFrom(
              backgroundColor: order.statusColor,
            ),
            child: Text(
              "Buyurtma yetkazildi",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: order.statusColor.computeLuminance() > 0.5
                    ? Color(0xFF000000)
                    : Color(0xFFFFFFFF),
              ),
            ),
          ),
        if(order.status == OrderStatus.delivred)
          ElevatedButton(
            onPressed: () =>
                _updateStatus(context, order, OrderStatus.cancelled),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              "O'chirish",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: order.statusColor.computeLuminance() > 0.5
                    ? Color(0xFF000000)
                    : Color(0xFFFFFFFF),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _updateStatus(
      BuildContext context, MyOrder order, OrderStatus status) async {
    try {
      await Provider.of<OrderProvider>(context, listen: false)
          .updateOrderStatus(order.id, status);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Buyurtma holati yangilandi"),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Xatolik: $e"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
