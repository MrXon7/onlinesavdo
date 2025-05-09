import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_savdo/core/constants/colors.dart';
import 'package:online_savdo/data/models/user_model.dart';
import 'package:online_savdo/presentation/pages/aboutUser.dart';
import 'package:online_savdo/presentation/pages/orders_page.dart';
import 'package:online_savdo/presentation/providers/user_provider.dart';
import 'package:online_savdo/presentation/widgets/profile_item.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            if (userProvider.user == null) {
              return Center(
                child: CircularProgressIndicator(
                  color: SweetShopColors.accent,
                ),
              );
            }
            final user = userProvider.user!;

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
                        Navigator.push(context, 
                            MaterialPageRoute(
                                builder: (context) => AboutUser()));
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
