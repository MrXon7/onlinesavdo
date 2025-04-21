import 'package:flutter/material.dart';
import 'package:online_savdo/core/constants/colors.dart';
import 'package:online_savdo/presentation/pages/browse_page.dart';
import 'package:online_savdo/presentation/pages/cart_page.dart';
import 'package:online_savdo/presentation/pages/home_page.dart';
import 'package:online_savdo/presentation/pages/profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late final List<Widget> _pages;
  late final List<AnimationController> _animationControllers;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    // Sahifalarni yaratish
    _pages = const [HomePage(), BrowsePage(), CartPage(), Profile()];

    // Animatsiya kontrollerlari
    _animationControllers = List.generate(
        _pages.length,
        (index) => AnimationController(
              vsync: this,
              duration: const Duration(milliseconds: 300),
            ));

    // Animatsiyalar
    _animations = _animationControllers
        .map(
          (controller) => Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: controller,
              curve: Curves.easeInOut,
            ),
          ),
        )
        .toList();

    // Dastlabki animatsiyani boshlash
    _animationControllers[_currentIndex].forward();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    // Yangi sahifa uchun animatsiyani boshlash
    _animationControllers[index].forward(from: 0);

    // Eskisini orqaga animatsiya
    _animationControllers[_currentIndex].reverse();

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: List.generate(
          _pages.length,
          (index) => AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Visibility(
                visible: _currentIndex == index,
                child: FadeTransition(
                    opacity: _animations[index],
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _animations[index],
                          curve: Curves.fastOutSlowIn,
                        ),
                      ),
                      child: _pages[index],
                    )),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: SweetShopColors.cardBackground,
          selectedItemColor: SweetShopColors.error,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Asosiy',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Qidirish',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Savatcha',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
