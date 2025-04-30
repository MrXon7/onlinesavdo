import 'dart:math';

import 'package:flutter/material.dart';
import 'package:online_savdo/core/constants/colors.dart';
import 'package:online_savdo/presentation/pages/admin_pages/admin_home.dart';
import 'package:online_savdo/presentation/pages/main_screen.dart';
import 'package:online_savdo/presentation/providers/auth_provider.dart';
import 'package:online_savdo/signup_page.dart';
import 'package:provider/provider.dart';

class CheckUserPage extends StatelessWidget {
  const CheckUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    if (authProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: SweetShopColors.accent,
        ),
      );
    } else if (authProvider.userData == null) {
      return const SignupPage();
    } else if (authProvider.telegramId == "5865675953") {
      return const AdminHomeScreen();
    }
    else {
      return const MainScreen();
    }
  }
}
