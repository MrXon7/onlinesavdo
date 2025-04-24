import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_savdo/core/constants/colors.dart';
import 'package:online_savdo/data/models/product_model.dart';
import 'package:online_savdo/presentation/providers/search_provider.dart';
import 'package:online_savdo/presentation/widgets/product_card.dart';
import 'package:provider/provider.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({super.key});

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // TextField o'zgarishlarini kuzatish uchun
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

// Qidiruv So'rovi o'zgarganda ishlaydi
  void _onSearchChanged() {
    final query = _searchController.text.trim();
    // Providerga qidiruv so'rovini yuborish
    Provider.of<SearchProvider>(context, listen: false)
        .searchProducts(context, query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buldSearchField(),
      ),
      body: Consumer<SearchProvider>(
        builder: (context, searchProvider, child) {
          // Yuklanayotgan paytd
          if (searchProvider.isSearching) {
            return const Center(
                child:
                    CircularProgressIndicator(color: SweetShopColors.primary));
          }

          // Xato bo'lsa
          if (searchProvider.errorMessage.isNotEmpty) {
            return Center(child: Text(searchProvider.errorMessage));
          }

          // Hechnima kiritilmagan bo'lsa oxirgi qidiruvlarni ko'rsatamiz
          if (searchProvider.searchQuery.isEmpty) {
            return Center(
              child: Text("Hech narsa qidirlmadi",
                  style: GoogleFonts.inter(fontSize: 16)),
            );
          }

          // Natija topilmasa
          if (searchProvider.searchResaults.isEmpty) {
            return _buildNoResoults();
          }
          // Natijalarni ko'rsatish uchun
          return _buildSearchResults(searchProvider.searchResaults);
        },
      ),
    );
  }

  // QIDIRUV MAYDONINI YARATISH
  Widget _buldSearchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.grey.shade300, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                  hintText: "Mahsulotlarni qidirish...",
                  border: InputBorder.none),
              style: GoogleFonts.inter(fontSize: 16),
            ),
          ),
          SizedBox(child: Icon(Icons.search, size: 32)),
        ],
      ),
    );
  }

  // Natija Topilmasa
  Widget _buildNoResoults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            '"${Provider.of<SearchProvider>(context).searchQuery}" uchun natija topilmadi',
            style: GoogleFonts.inter(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text("Boshqa kalit so'zlar bilan urinib ko'ring",
              style: GoogleFonts.inter())
        ],
      ),
    );
  }

// Qidiruv natijalarini ko'rsatish Natijalarni ko'rsatish
  Widget _buildSearchResults(List<Product> products) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
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
    ),
    );
  }
}
