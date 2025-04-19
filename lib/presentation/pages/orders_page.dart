import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_savdo/presentation/providers/auth_provider.dart';
import 'package:online_savdo/presentation/providers/order_provider.dart';
import 'package:online_savdo/presentation/widgets/order_cart.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //     Provider.of<OrderProvider>(context, listen: false).fetchOrders(authProvider.telegramId!);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Mening Buyurtmalari",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.orders.isEmpty) {
            return Center(
              child: Text(
                "Sizda hali buyurtmalar mavjud emas",
                style: GoogleFonts.inter(),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => orderProvider.fetchOrders(authProvider.telegramId!),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                  itemCount: orderProvider.orders.length,
                  itemBuilder: (context, index) {
                    final order = orderProvider.orders[index];
                    return OrderCart(order: order);
                  }),
            ),
          );
        },
      ),
    );
  }
}
