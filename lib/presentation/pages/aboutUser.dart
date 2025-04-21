import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_savdo/presentation/providers/user_provider.dart';
import 'package:online_savdo/presentation/widgets/shaxsiyListTile.dart';
import 'package:online_savdo/presentation/widgets/showInputDialog.dart';
import 'package:provider/provider.dart';

class AboutUser extends StatelessWidget {
  const AboutUser({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mening Ma'lumotlarim",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            ShaxsiyListTile(
                title: "FISH",
                subtitle: user!.name,
                icon: Icons.person,
                onTap: () =>
                    ShowInputDialog(context, "name", "Ismingizni kiriting")),
            const SizedBox(height: 5),
            ShaxsiyListTile(
                title: "Telefon",
                subtitle: user.phone,
                icon: Icons.phone,
                onTap: () => ShowInputDialog(
                    context, "phone", "Tel-raqamingizni kiriting")),
            const SizedBox(height: 5),
            ShaxsiyListTile(
                title: "Manzil ",
                subtitle: user.address,
                icon: Icons.location_on,
                onTap: () => ShowInputDialog(
                    context, "address", "Manzilingizni kiriting")),
          ],
        ),
      ),
    );
  }
}
