import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_savdo/core/constants/colors.dart';
import 'package:online_savdo/data/models/user_model.dart';
import 'package:online_savdo/presentation/pages/admin_pages/admin_home.dart';
import 'package:online_savdo/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _phone;

  String? _validatePhone(String? value) {
    final pattern = r'^\+998[0-9]{9}$';
    final regExp = RegExp(pattern);
    String phone = "+998${value ?? ''}";
    if (value == null || value.isEmpty) {
      return 'Telefon raqamini kiriting';
    } else if (!regExp.hasMatch(phone)) {
      return "Telefon raqamni to'g'ri kiriting";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    void _regstruser() async {
      try {
        final newuser = User(
            id: authProvider.telegramId!,
            name: _name!,
            phone: _phone!,
            address: "",
            cartItems: []);

        await authProvider.registerUser(newuser, context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AdminHomeScreen()));
      } catch (e) {
        print("Error: $e");
      }
    }

    return Stack(
      children: [
        Image.asset(
          "signup/signup2.jpg",
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: authProvider.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: SweetShopColors.accent,
                  ),
                )
              : Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      width: 400,
                      height: 500,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 32),
                      decoration: BoxDecoration(
                        // color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Blur effekti uchun BackdropFilter
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                16.0), // Chegaralarni yumaloqlash
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                  sigmaX: 5.0, sigmaY: 5.0), // Blur effekti
                              child: Container(
                                color: Colors.black
                                    .withOpacity(0.2), // Shaffof qoplama
                              ),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Ro'yxatdan o'tish",
                                  style: GoogleFonts.inter(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 32),
                                SizedBox(
                                  width: 300,
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          style: const TextStyle(
                                              color: Colors.white),
                                          decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            labelText: "Ism",
                                            labelStyle:
                                                TextStyle(color: Colors.white),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
                                            ),
                                          ),
                                          validator: (value) => value!.isEmpty
                                              ? "Ismingizni kiriting"
                                              : null,
                                          onSaved: (value) {
                                            _name = value;
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          style: const TextStyle(
                                              color: Colors.white),
                                          decoration: InputDecoration(
                                            labelText: "Telefon raqami",
                                            labelStyle:
                                                TextStyle(color: Colors.white),
                                            prefix: Text(
                                              "+998",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
                                            ),
                                          ),
                                          keyboardType: TextInputType.phone,
                                          validator: _validatePhone,
                                          onSaved: (value) {
                                            _phone = "+998$value";
                                          },
                                        ),
                                        const SizedBox(height: 32),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.pink,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 32, vertical: 16),
                                          ),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _formKey.currentState!.save();
                                              _regstruser();
                                            }
                                          },
                                          child: Text(
                                            "Ro'yxatdan o'tish",
                                            style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
