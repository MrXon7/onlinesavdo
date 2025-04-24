import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_savdo/core/constants/colors.dart';
import 'package:online_savdo/data/models/product_model.dart';
import 'package:online_savdo/presentation/pages/productDetail_page.dart';
import 'package:online_savdo/presentation/providers/auth_provider.dart';
import 'package:online_savdo/presentation/providers/cart_provider.dart';
import 'package:online_savdo/presentation/providers/order_provider.dart';
import 'package:online_savdo/presentation/providers/product_provider.dart';
import 'package:online_savdo/presentation/providers/user_provider.dart';
import 'package:online_savdo/presentation/widgets/product_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  // agar satefull widgetga o'tkazilsa quyidagini almashtirish
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      Provider.of<CartProvider>(context, listen: false)
          .fetchCartItems(authProvider.telegramId!);
      Provider.of<OrderProvider>(context, listen: false)
          .fetchOrders(authProvider.telegramId!);
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchPrducts();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      Provider.of<UserProvider>(context, listen: false)
          .loadUserData(authProvider.telegramId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: SweetShopColors.accent,
        ),
      );
    }
    return Scaffold(
      backgroundColor: SweetShopColors.cardBackground,
      appBar: AppBar(
        title: Text(
          'Salom ${user.name}',
          style: GoogleFonts.inter(
            color: SweetShopColors.textDark,
            fontSize: 28.0,
            fontWeight: FontWeight.w900, // Maximum qalinlik
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDealsList(context),
              _buildRecommendedHeader(),
              const SizedBox(height: 16),
              _buildRecommendedProducts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDealsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Kunlik chegirmalar',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: SweetShopColors.textDark,
          ),
        ),
        // TextButton(
        //   onPressed: () {},
        //   child: const Text('See all'),
        // ),
      ],
    );
  }

// chegirma cardlari
  Widget _buildDealsList(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products;
    // Chegirma kartalarini yaratish uchun List<Widget> ga o'tkazamiz
    List<Widget> DealItems = products
        .map((product) {
          if (product.discount > 0) {
            return _buildDealItem(product, context);
          }
          return null; // Agar chegirma bo'lmasa, bo'sh widget qaytaramiz
        })
        .whereType<Widget>()
        .toList();

    return DealItems.length > 0
        ? SizedBox(
            height: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              children: [
                _buildDealsHeader(),
                const SizedBox(height: 6),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      _currentPage.value = index;
                    },
                    children: DealItems,
                  ),
                ),
                ValueListenableBuilder(
                    valueListenable: _currentPage,
                    builder: (context, currentPage, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            DealItems.length, // Kartalar soni
                            (index) => _buildIndicator(index == currentPage)),
                      );
                    }),
              ],
            ),
          )
        : const SizedBox();
  }

// Chegirma cart indicatori
  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: isActive ? 20.0 : 8.0,
      height: 5.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }

// Chegirma cart itemi
  Widget _buildDealItem(Product product, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailPage(
            product: product,
            isAdmin: false,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        decoration: BoxDecoration(
          color: SweetShopColors.candyColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: //Image(image: NetworkImage(imageUrl))
                    Image.network(
                  product.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        color: SweetShopColors.textDark,
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: MediaQuery.of(context).size.width * 0.025,
                        color: SweetShopColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${(product.discount + product.price)} so'm",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: MediaQuery.of(context).size.width * 0.036,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${product.price} so'm",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.038,
                            color: SweetShopColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedHeader() {
    return Text(
      'Bizning mahsilotlar',
      style: GoogleFonts.inter(
        fontSize: 20,
        color: SweetShopColors.textDark,
        fontWeight: FontWeight.bold,
      ),
    );
  }

// Recomended GridView
  Widget _buildRecommendedProducts() {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          mainAxisExtent: 268,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}
