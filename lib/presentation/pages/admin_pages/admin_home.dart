import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_savdo/core/constants/colors.dart';
import 'package:online_savdo/presentation/pages/admin_pages/adm_orders_screen.dart';
import 'package:online_savdo/presentation/pages/admin_pages/productsScreen.dart';
import 'package:online_savdo/presentation/pages/admin_pages/settings.dart';
import 'package:online_savdo/presentation/pages/main_screen.dart';
import 'package:online_savdo/presentation/providers/order_provider.dart';
import 'package:online_savdo/presentation/providers/product_provider.dart';
import 'package:provider/provider.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int selectedIndex = 0;
  final List<Widget> pages = [
    const ProductsScreen(),
    const AdmOrdersScreen(),
    const Center(child: Text("Stats Page")),
    AdminSettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchPrducts();
      // Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MainScreen()));
            },
            icon: Icon(Icons.person)),
        title: Text("Admin Panel",
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.production_quantity_limits),
              label: "Mahsulotlar"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Buyurtmalar"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: "Statistika"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Sozlamalar"),
        ],
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: SweetShopColors.cardBackground,
        selectedItemColor: SweetShopColors.error,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
