import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_savdo/data/models/order_model.dart';
import 'package:online_savdo/presentation/providers/order_provider.dart';
import 'package:online_savdo/presentation/widgets/adm_order_card.dart';
import 'package:provider/provider.dart';

class AdmOrdersScreen extends StatefulWidget {
  const AdmOrdersScreen({super.key});

  @override
  State<AdmOrdersScreen> createState() => _AdmOrdersScreenState();
}

class _AdmOrdersScreenState extends State<AdmOrdersScreen> {
  // Qaysi panel ochiq ekanligini bilish uchun
  final Map<String, bool> _expansionStates = {};
  bool isexpanded = false;
  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrderProvider>(context);
    return RefreshIndicator(
      onRefresh: () async {
        // ADMIN uchun alohida buyurtmalarni yuklab olish f-ya si yaratiladi
        // await ordersProvider.fetchOrders();
      },
      child: Scaffold(
          // appBar: AppBar(
          //   title: Text(
          //     "Buyurtmalar",
          //     style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          //   ),
          // ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildStatusGroup(
                  context,
                  title: "Yangi buyurtmalar",
                  orders: ordersProvider.pendingingOrders,
                  statusColor: Colors.grey,
                ),
                _buildStatusGroup(
                  context,
                  title: "Jarayonda",
                  orders: ordersProvider.proccessingOrders,
                  statusColor: Colors.green,
                ),
                const SizedBox(height: 16),
                _buildStatusGroup(
                  context,
                  title: "Yetkazilmoqda",
                  orders: ordersProvider.shippedOrders,
                  statusColor: Colors.blue,
                ),
                const SizedBox(height: 16),
                _buildStatusGroup(
                  context,
                  title: "Yetkazib berilgan buyurtmalar",
                  orders: ordersProvider.delivredOrders,
                  statusColor: Colors.orange,
                ),
                const SizedBox(height: 16),
                _buildStatusGroup(
                  context,
                  title: "Bekor qilingan buyurtmalar",
                  orders: ordersProvider.cancelledOrders,
                  statusColor: Colors.orange,
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildStatusGroup(
    BuildContext context, {
    required String title,
    required List<MyOrder> orders,
    required Color statusColor,
  }) {
    for (var order in orders) {
      _expansionStates.putIfAbsent(order.id, () => false);
    }

    return ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: const EdgeInsets.all(0),
        expansionCallback: (int index, bool isExpanded) {
          if(orders.isNotEmpty) {
           setState(() {
            _expansionStates[orders[index].id] =
                !_expansionStates[orders[index].id]!;
            // isExpanded = !isExpanded;
          });
          }
          
        },
        children: orders.isNotEmpty
            ? [
                ExpansionPanel(
                  backgroundColor: Colors.transparent,
                  headerBuilder: (context, isExpanded) {
                    return Text(title,
                        style: GoogleFonts.inter(
                            fontSize: 16, fontWeight: FontWeight.bold));
                  },
                  body: Column(
                    children: orders
                        .map((order) => AdmOrderCart(order: order))
                        .toList(),
                  ),
                  isExpanded: _expansionStates[orders[0].id] ?? false,
                ),
              ]
            : [
                ExpansionPanel(
                  backgroundColor: Colors.transparent,
                  headerBuilder: (context, isExpanded) {
                    return Text(title,
                        style: GoogleFonts.inter(
                            fontSize: 16, fontWeight: FontWeight.bold));
                  },
                  body: Text("Ma'lumot mavjud emas"),
                  isExpanded: true,
                ),
              ]);
  }
}
