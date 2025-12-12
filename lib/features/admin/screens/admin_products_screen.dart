import 'package:flutter/cupertino.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/product_service.dart';
import '../../../core/routes/app_routes.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  final ProductService _productService = ProductService();
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
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Error'),
            content:  Text('Failed to load products:  $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _deleteProduct(Product product) async {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete ${product.name}?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child:  const Text('Delete'),
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _productService. deleteProduct(product.id);
                _loadProducts();
                if (mounted) {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('Success'),
                      content: const Text('Product deleted successfully'),
                      actions:  [
                        CupertinoDialogAction(
                          child: const Text('OK'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('Error'),
                      content: Text('Failed to delete product: $e'),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('OK'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _navigateToAddProduct() async {
    final result = await Navigator.pushNamed(context, AppRoutes.adminAddProduct);
    if (result == true) {
      _loadProducts();
    }
  }

  void _navigateToEditProduct(Product product) async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes. adminEditProduct,
      arguments:  product,
    );
    if (result == true) {
      _loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          'Manage Products',
          style: TextStyle(color: Color(0xFF2C3E50)),
        ),
        backgroundColor: const Color(0xFFF8F5F0),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: const Icon(
            CupertinoIcons.back,
            color: Color(0xFF2C3E50),
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets. zero,
          onPressed: _navigateToAddProduct,
          child: const Icon(
            CupertinoIcons.add_circled,
            color: Color(0xFF8A9A5B),
            size: 28,
          ),
        ),
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : _products.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                CupertinoIcons.cube_box,
                size: 64,
                color: Color(0xFFD1D5DB),
              ),
              const SizedBox(height: 16),
              const Text(
                'No products yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 24),
              CupertinoButton(
                color: const Color(0xFF8A9A5B),
                onPressed: _navigateToAddProduct,
                child:  const Text('Add First Product'),
              ),
            ],
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount:  _products.length,
          itemBuilder: (context, index) {
            final product = _products[index];
            return _buildProductCard(product);
          },
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child:  Image.network(
              product. imageUrl,
              width: 100,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 100,
                height:  120,
                color: const Color(0xFFE5E7EB),
                child: const Icon(
                  CupertinoIcons.photo,
                  size: 32,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ),
          ),

          // Product Info
          Expanded(
            child:  Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height:  4),
                  Text(
                    product.category,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8A9A5B),
                    ),
                  ),
                  const SizedBox(height:  8),
                  Row(
                    children: [
                      Text(
                        '\$${product.price. toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Stock: ${product.stock}',
                        style: TextStyle(
                          fontSize: 13,
                          color: product.stock > 0
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Actions
          Column(
            children: [
              CupertinoButton(
                padding: const EdgeInsets.all(8),
                onPressed: () => _navigateToEditProduct(product),
                child: const Icon(
                  CupertinoIcons.pencil,
                  color: Color(0xFF8A9A5B),
                  size: 22,
                ),
              ),
              CupertinoButton(
                padding: const EdgeInsets.all(8),
                onPressed: () => _deleteProduct(product),
                child: const Icon(
                  CupertinoIcons. delete,
                  color: Color(0xFFEF4444),
                  size: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}