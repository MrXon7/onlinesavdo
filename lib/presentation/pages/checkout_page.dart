import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_savdo/core/constants/colors.dart';
import 'package:online_savdo/data/models/user_model.dart';
import 'package:online_savdo/presentation/pages/orders_page.dart';
import 'package:online_savdo/presentation/providers/auth_provider.dart';
import 'package:online_savdo/presentation/providers/cart_provider.dart';
import 'package:online_savdo/presentation/providers/order_provider.dart';
import 'package:online_savdo/presentation/providers/user_provider.dart';
import 'package:online_savdo/presentation/widgets/cart_item_card.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _fromKey = GlobalKey<FormState>();

  late String _paymentMethod = "Naqd";
  late bool _isLoading = false;
  // COntrollerlea
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _customeristak = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // await userProvider.loadUserData();

    if (userProvider.user != null) {
      final user = userProvider.user!;
      _nameController.text = user.name;
      _phoneController.text = user.phone;
      _addressController.text = user.address;
    }
  }

// Buyurtma berish va API ga uzatish
  Future<void> _placeOrder() async {
    if (!_fromKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userProvider = Provider.of<AuthProvider>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final user = userProvider.userData!;

      await orderProvider.placeOrder(
          items: cartProvider.items,
          totalAmount: cartProvider.totalAmount,
          paymentMethod: _paymentMethod,
          customer: User(
              id: user.id,
              name: _nameController.text,
              phone: _phoneController.text,
              address: _addressController.text,
              cartItems: []
              ),
              istak: _customeristak.text
              );

      // Buyurtma Muvaffaqiyatli bo'lsa
      cartProvider.clearCart(user.id);
      // Buyurtmani tasdiqlash
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => OrdersPage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("Xatolik yuz berdi ${e.toString()}")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Buyurtma berish",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: SweetShopColors.accent,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _fromKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Foydalanuvchi ma'lumotlari",
                        style: GoogleFonts.inter(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    // Mijoz ismi
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                          labelText: "Ismingiz", border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Iltimos, ismingizni kiriting";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Telefon raqami
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                          labelText: "Tel Raqamingiz",
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Iltimos, Raqamingizni kiriting";
                        }
                        return null;
                      },
                      // onChanged: (value) => _phoneNumber = value,
                    ),
                    const SizedBox(height: 16),
                    // Manzil
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                          labelText: "Yetkazish manzili",
                          border: OutlineInputBorder()),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Iltimos, Yetkazish manzilini kiriting";
                        }
                        return null;
                      },
                      // onChanged: (value) => _delevryAddress = value,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _customeristak,
                      decoration: const InputDecoration(
                          // labelText: "Foydalanuvchi istaklari",
                          hintText: "Buyurtma bo'yicha o'z istaklaringizni yozing, bu uchun qo'shimcha haq olinishi mumkin",
                          border: OutlineInputBorder()),
                      maxLines: 3,
                      // onChanged: (value) => _delevryAddress = value,
                    ),
                    const SizedBox(height: 32),

                    Text("Buyurtma tafsilotlari",
                        style: GoogleFonts.inter(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    // Mahsulotlar ro'yxati
                    ...cartProvider.items.map((item) => CartItemCard(
                          cartItem: item,
                          isOrdered: true,
                        )),

                    const Divider(height: 32),
                    // Jami summa
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Jami:",
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        Text(
                          "${NumberFormat('#,###').format(cartProvider.totalAmount)} so'm",
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        )
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Buyurtma berish tugmasi
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: _isLoading ? null : _placeOrder,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: SweetShopColors.accent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              )),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : Text("Buyurtma Berish",
                                  style: GoogleFonts.inter(
                                      fontSize: 18, color: Colors.white))),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
