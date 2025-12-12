import 'package:flutter/cupertino.dart';
import '../../../data/models/product_model.dart';  // ✅ Use relative path
import '../../../data/services/product_service.dart';  // ✅ Use relative path

class AdminAddEditProductScreen extends StatefulWidget {
  final Product? product;

  const AdminAddEditProductScreen({super.key, this.product});

  @override
  State<AdminAddEditProductScreen> createState() =>
      _AdminAddEditProductScreenState();
}

class _AdminAddEditProductScreenState extends State<AdminAddEditProductScreen> {
  final ProductService _productService = ProductService();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;
  late TextEditingController _stockController;
  late TextEditingController _imageUrlController;
  bool _featured = false;
  bool _isLoading = false;

  bool get isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ??  '');
    _descriptionController =
        TextEditingController(text: widget.product?.description ?? '');
    _priceController =
        TextEditingController(text: widget.product?.price. toString() ?? '');
    _categoryController =
        TextEditingController(text: widget.product?.category ?? '');
    _stockController =
        TextEditingController(text: widget.product?.stock.toString() ?? '');
    _imageUrlController =
        TextEditingController(text: widget.product?.imageUrl ??  '');
    _featured = widget.product?.featured ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _stockController.text.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Validation Error'),
          content: const Text('Please fill all required fields'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final product = Product(
        id: widget.product?.id ??  '',
        name: _nameController. text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        category: _categoryController.text,
        stock: int.tryParse(_stockController.text) ?? 0,
        imageUrl: _imageUrlController.text,
        featured: _featured,
        createdAt: widget.product?.createdAt ?? DateTime.now(),
      );

      if (isEditing) {
        await _productService.updateProduct(widget.product! .id, product);
      } else {
        await _productService.addProduct(product);
      }

      if (mounted) {
        Navigator. pop(context, true);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Error'),
            content:  Text('Failed to save product: $e'),
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          isEditing ? 'Edit Product' : 'Add Product',
          style: const TextStyle(color: Color(0xFF2C3E50)),
        ),
        backgroundColor: const Color(0xFFF8F5F0),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        trailing: _isLoading
            ? const CupertinoActivityIndicator()
            : CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _saveProduct,
          child:  const Text(
            'Save',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF8A9A5B),
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTextField(
              controller: _nameController,
              label: 'Product Name *',
              placeholder: 'e.g., Silk Scarf',
            ),
            _buildTextField(
              controller: _descriptionController,
              label:  'Description',
              placeholder:  'Product description.. .',
              maxLines: 3,
            ),
            _buildTextField(
              controller: _priceController,
              label: 'Price *',
              placeholder: '0.00',
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              prefix: const Text('\$'),
            ),
            _buildTextField(
              controller: _categoryController,
              label: 'Category',
              placeholder: 'e.g., Accessories',
            ),
            _buildTextField(
              controller: _stockController,
              label: 'Stock *',
              placeholder: '0',
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              controller: _imageUrlController,
              label: 'Image URL',
              placeholder: 'https://...',
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  const Text(
                    'Featured Product',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  CupertinoSwitch(
                    value: _featured,
                    activeTrackColor: const Color(0xFF8A9A5B),
                    onChanged: (value) => setState(() => _featured = value),
                  ),
                ],
              ),
            ),
            if (_imageUrlController.text.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Image Preview',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        _imageUrlController.text,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.photo,
                              size: 48,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    int maxLines = 1,
    TextInputType?  keyboardType,
    Widget? prefix,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          CupertinoTextField(
            controller: controller,
            placeholder: placeholder,
            maxLines: maxLines,
            keyboardType: keyboardType,
            prefix: prefix != null
                ?  Padding(
              padding: const EdgeInsets.only(left: 12),
              child: prefix,
            )
                : null,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
          ),
        ],
      ),
    );
  }
}