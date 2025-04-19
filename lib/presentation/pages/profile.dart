import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_savdo/core/constants/colors.dart';
import 'package:online_savdo/data/models/user_model.dart';
import 'package:online_savdo/presentation/pages/orders_page.dart';
import 'package:online_savdo/presentation/providers/auth_provider.dart';
import 'package:online_savdo/presentation/widgets/profile_item.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Sahifa yuklanganida foydalanuvchi ma'lumotlarini olamiz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Provider.of<UserProvider>(context, listen: false).loadUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<AuthProvider>(
          builder: (context, userProvider, child) {
            if (userProvider.userData == null) {
              return Center(
                child: CircularProgressIndicator(
                  color: SweetShopColors.accent,
                ),
              );
            }
            final user = userProvider.userData!;

            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildProfileHeader(user),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    // Profile Bo'limlari
                    ProfileItem(
                      icon: Icons.person_outline,
                      title: "Shaxsiy ma'lumotlar",
                      onTap: () {
                        // shaxsiy ma'lumotlarga o'tish
                      },
                    ),
                    ProfileItem(
                      icon: Icons.shopping_bag_outlined,
                      title: "Mening buyurtmalarim",
                      onTap: () {
                        // Mening buyurtmalarimga o'tish
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrdersPage()));
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: SweetShopColors.iceCreamColor,
          child: Text(
            user.name[0],
            style: GoogleFonts.inter(fontSize: 48, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          user.name,
          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          user.phone,
          style: GoogleFonts.inter(color: Colors.grey),
        )
      ],
    );
  }
}
