import 'package:flutter/cupertino.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/product_service.dart';
import 'product_card.dart';
import 'home_footer.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final ProductService _productService = ProductService();
  String _selectedCategory = 'ALL';
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    try {
      final products = await _productService.getAllProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error loading products: $e');
    }
  }

  List<Product> get _filteredProducts {
    if (_selectedCategory == 'ALL') {
      return _products;
    }
    return _products
        .where((product) => product.category. toUpperCase() == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Hero Section
        SliverToBoxAdapter(
          child: Container(
            height: 300,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8A9A5B),
                  Color(0xFF2C3E50),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'ÉCLAT',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 8,
                      color: Color(0xFFF8F5F0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Curated Luxury Collection',
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 2,
                      color: const Color(0xFFF8F5F0).withValues(alpha: 0.8),  // ✅ Fixed
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ✅ Category Filter Buttons - FINAL FIX FOR SCROLLBAR POSITION
        SliverToBoxAdapter(
          child: Container(
            color: const Color(0xFFF8F5F0),
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column( // Wrapped Row in a Column
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row( // The original Row containing buttons
                    children: [
                      _buildCategoryButton('ALL'),
                      const SizedBox(width: 16),
                      _buildCategoryButton('ACCESSORIES'),
                      const SizedBox(width: 16),
                      _buildCategoryButton('BAGS'),
                      const SizedBox(width: 16),
                      _buildCategoryButton('CLOTHING'),
                      const SizedBox(width: 16),
                      _buildCategoryButton('JEWELRY'),
                      const SizedBox(width: 16),
                      _buildCategoryButton('WATCHES'),
                    ],
                  ),
                  // *** CRUCIAL FIX: Explicit height for scrollbar space ***
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),

        // ✅ Section Title - STAYS BELOW CATEGORIES
        SliverToBoxAdapter(
          child: Container(
            color: const Color(0xFFF8F5F0),
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FEATURED PRODUCTS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 3,
                    color: Color(0xFF8A9A5B),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 50,
                  height: 2,
                  color: const Color(0xFF8A9A5B),
                ),
              ],
            ),
          ),
        ),

        // Loading or Product Grid
        _isLoading
            ? const SliverToBoxAdapter(
          child: Center(
            child:  Padding(
              padding: EdgeInsets.all(40),
              child: CupertinoActivityIndicator(),
            ),
          ),
        )
            : _filteredProducts.isEmpty
            ?  SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  const Icon(
                    CupertinoIcons.cube_box,
                    size: 64,
                    color: Color(0xFFD1D5DB),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _selectedCategory == 'ALL'
                        ? 'No products available'
                        : 'No products in $_selectedCategory',
                    style:  const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
            : SliverPadding(
          padding:  const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final product = _filteredProducts[index];
                return ProductCard(
                  name: product.name,
                  price: '\$${product.price.toStringAsFixed(2)}',
                  imageUrl: product.imageUrl,
                  product: product,
                );
              },
              childCount: _filteredProducts.length,
            ),
          ),
        ),

        // Spacing before footer
        const SliverToBoxAdapter(
          child: SizedBox(height: 48),
        ),

        // Footer
        const SliverToBoxAdapter(
          child: HomeFooter(),
        ),
      ],
    );
  }

  Widget _buildCategoryButton(String category) {
    final isSelected = _selectedCategory == category;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategory = category;
          });
        },
        child:  Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ?  const Color(0xFF8A9A5B) : const Color(0xFFF5F3F0),
            borderRadius:  BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF8A9A5B) : const Color(0xFFD1C4B0),
              width: 1,
            ),
          ),
          child: Text(
            category,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: isSelected ?  const Color(0xFFF8F5F0) : const Color(0xFF666666),
            ),
          ),
        ),
      ),
    );
  }
}