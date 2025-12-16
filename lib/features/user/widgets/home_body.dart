import 'package:flutter/cupertino.dart';
import '../../../data/models/product_model.dart';
import 'package:flutter/material.dart';
import '../../../data/services/product_service.dart';
import 'product_card.dart';
import 'home_footer.dart';

class HomeBody extends StatefulWidget {
  final Function(double)? onScrollUpdate;

  const HomeBody({
    super.key,
    this.onScrollUpdate,
  });

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final ProductService _productService = ProductService();
  String _selectedCategory = 'ALL';
  List<Product> _products = [];
  bool _isLoading = true;

  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _loadProducts();

    _scrollController.addListener(() {
      final newOffset = _scrollController.offset;
      if (newOffset != _scrollOffset) {
        setState(() {
          _scrollOffset = newOffset;
        });

        widget.onScrollUpdate?.call(newOffset);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
        .where((product) => product.category.toUpperCase() == _selectedCategory)
        .toList();
  }

  double get _bannerTextOpacity {
    return 1.0 - (_scrollOffset / 180).clamp(0, 1);
  }

  double get _bannerTextScale {
    return 1.0 - (_scrollOffset / 200).clamp(0, 0.6);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            height: 300,
            child: Stack(
              children: [
                // BANNER IMAGE - REPLACED GRADIENT
                Image.asset(
                  'assets/images/banner.jpg', // Your banner image path
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover, // Covers the entire area
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to gradient if image doesn't exist
                    return Container(
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
                    );
                  },
                ),

                // DARK OVERLAY FOR BETTER TEXT READABILITY
                Container(
                  height: 300,
                  color: Colors.black.withOpacity(0.2), // Semi-transparent overlay
                ),

                // Curated Luxury Collection - Now BELOW ÉCLAT
                Positioned(
                  left: 24,
                  bottom: 80,
                  child: Text(
                    'Curated Luxury Collection',
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 2,
                      color: const Color(0xFFF8F5F0).withOpacity(0.9), // Brighter for image
                    ),
                  ),
                ),

                // ÉCLAT Text - NOW ABOVE Curated Luxury Collection
                Positioned(
                  left: 24,
                  bottom: 120,
                  child: AnimatedOpacity(
                    opacity: _bannerTextOpacity,
                    duration: Duration.zero,
                    child: Transform.scale(
                      scale: _bannerTextScale,
                      child: const Text(
                        'ÉCLAT',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 8,
                          color: Color(0xFFF8F5F0), // White text
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Rest of your code remains exactly the same...
        SliverToBoxAdapter(
          child: Container(
            color: const Color(0xFFF8F5F0),
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
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
            ),
          ),
        ),

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

        _isLoading
            ? const SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CupertinoActivityIndicator(),
            ),
          ),
        )
            : _filteredProducts.isEmpty
            ? SliverToBoxAdapter(
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
                    style: const TextStyle(
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final product = _filteredProducts[index];
                return ProductCard(
                  name: product.name ?? "No name",
                  price: product.price != null
                      ? '\$${product.price!.toStringAsFixed(2)}'
                      : "-",
                  imageUrl: product.imageUrl ?? "",
                  product: product,
                );
              },
              childCount: _filteredProducts.length,
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 48),
        ),
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF8A9A5B) : const Color(0xFFF5F3F0),
            borderRadius: BorderRadius.circular(20),
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
              color: isSelected ? const Color(0xFFF8F5F0) : const Color(0xFF666666),
            ),
          ),
        ),
      ),
    );
  }
}