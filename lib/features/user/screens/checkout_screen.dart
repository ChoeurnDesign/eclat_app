import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../data/services/cart_service.dart';
import '../../../data/services/payment_service.dart';
import '../../../data/services/order_service.dart';
import '../widgets/payment_options_modal.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String?  _selectedPaymentMethod;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          'Checkout',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: const Color(0xFFF8F5F0),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _isProcessing ? null : () => Navigator.pop(context),
          child: Icon(
            CupertinoIcons.back,
            color: _isProcessing ? const Color(0xFF9CA3AF) : const Color(0xFF2C3E50),
          ),
        ),
      ),
      child: SafeArea(
        child: Consumer<CartService>(
          builder:  (context, cartService, child) {
            if (cartService.items.isEmpty) {
              return _buildEmptyCart();
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildOrderSummary(cartService),
                        const SizedBox(height: 24),
                        _buildPaymentMethodSection(),
                        const SizedBox(height: 24),
                        _buildOrderTotal(cartService),
                      ],
                    ),
                  ),
                ),
                _buildPlaceOrderButton(cartService),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child:  Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.cart,
              size: 80,
              color: const Color(0xFF8A9A5B).withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height:  32),
            CupertinoButton(
              color: const Color(0xFF8A9A5B),
              borderRadius: BorderRadius.circular(24),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Continue Shopping',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(CartService cartService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment. start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height:  16),
        ...cartService.items.map((item) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image. network(
                  item.product.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: const Color(0xFFE5E7EB),
                    child: const Icon(CupertinoIcons.photo),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:  CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product. name,
                      style: const TextStyle(
                        fontSize:  14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Qty: ${item.quantity}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${(item.product.price * item. quantity).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize:  16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8A9A5B),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
            letterSpacing:  0.3,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _isProcessing ? null : _showPaymentOptions,
          child:  Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _selectedPaymentMethod != null
                    ? const Color(0xFF8A9A5B)
                    : const Color(0xFFE5E7EB),
                width: _selectedPaymentMethod != null ?  2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _selectedPaymentMethod != null
                      ? CupertinoIcons.checkmark_circle_fill
                      : CupertinoIcons.circle,
                  color: _selectedPaymentMethod != null
                      ?  const Color(0xFF8A9A5B)
                      : const Color(0xFF9CA3AF),
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _selectedPaymentMethod ??  'Select payment method',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:  FontWeight.w500,
                      color: _selectedPaymentMethod != null
                          ? const Color(0xFF2C3E50)
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
                const Icon(
                  CupertinoIcons.chevron_right,
                  color: Color(0xFF9CA3AF),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderTotal(CartService cartService) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors. white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              const Text(
                'Subtotal',
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
              Text(
                '\$${cartService.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  const [
              Text(
                'Shipping',
                style: TextStyle(fontSize: 14, color:  Color(0xFF6B7280)),
              ),
              Text(
                'FREE',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(height: 1, color: const Color(0xFFE5E7EB)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              Text(
                '\$${cartService.total. toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8A9A5B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton(CartService cartService) {
    final canPlaceOrder = _selectedPaymentMethod != null && ! _isProcessing;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        boxShadow: [
          BoxShadow(
            color:  const Color(0xFF000000).withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: canPlaceOrder ? () => _processOrder(cartService) : null,
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: canPlaceOrder
                ? const Color(0xFF2C3E50)
                : const Color(0xFF9CA3AF),
            borderRadius: BorderRadius.circular(26),
          ),
          alignment: Alignment.center,
          child: _isProcessing
              ? const CupertinoActivityIndicator(color: CupertinoColors.white)
              : const Text(
            'PLACE ORDER',
            style:  TextStyle(
              fontSize:  15,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF8F5F0),
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  void _showPaymentOptions() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => PaymentOptionsModal(
        onPaymentSelected: (paymentMethod) {
          setState(() {
            _selectedPaymentMethod = paymentMethod;
          });
        },
      ),
    );
  }

  Future<void> _processOrder(CartService cartService) async {
    if (_selectedPaymentMethod == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // ✅ Get all dependencies BEFORE any await
      final paymentService = Provider.of<PaymentService>(context, listen: false);
      final orderService = OrderService();
      final navigator = Navigator.of(context);

      // Step 1: Create order
      final orderId = await orderService.createOrder(
        cartItems: cartService.items,
        total: cartService.total,
        paymentMethod: _selectedPaymentMethod! ,
      );

      if (orderId == null) throw Exception('Failed to create order');

      // Step 2: Process payment
      final paymentSuccess = await paymentService.processPayment(
        amount: cartService.total,
        method: PaymentMethod.visa,
        orderId: orderId,
      );

      if (!paymentSuccess) throw Exception('Payment failed');

      // Step 3: Clear cart ONLY after successful payment
      cartService.clearCart();

      // ✅ Check mounted before setState
      if (! mounted) return;

      setState(() {
        _isProcessing = false;
      });

      // Step 4: Show success - ✅ Use BuildContext from showCupertinoDialog's builder
      showCupertinoDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => CupertinoAlertDialog(
          title: const Text(
            'Order Successful!',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          content:  Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Order #$orderId\nPayment: $_selectedPaymentMethod\n\nThank you for your purchase!',
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                letterSpacing: 0.3,
              ),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed:  () {
                Navigator.pop(dialogContext); // Close dialog
                navigator.pop(); // Close checkout
                navigator.pop(); // Close cart
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF007AFF),
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      // ✅ Check mounted before setState
      if (!mounted) return;

      setState(() {
        _isProcessing = false;
      });

      // ✅ Use BuildContext from showCupertinoDialog's builder
      showCupertinoDialog<void>(
        context: context,
        builder: (dialogContext) => CupertinoAlertDialog(
          title: const Text(
            'Order Failed',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          content: Padding(
            padding:  const EdgeInsets.only(top: 8),
            child:  Text(
              'Error: $e\n\nPlease try again.',
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                letterSpacing: 0.3,
              ),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight:  FontWeight.w600,
                  color: Color(0xFF007AFF),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}