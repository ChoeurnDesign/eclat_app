import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../data/services/cart_service.dart';
import '../../../data/services/payment_service.dart';
import '../../../data/services/order_service.dart';
import '../widgets/payment_options_modal.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          'Shopping Cart',
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
          onPressed: () => Navigator.pop(context),
          child: const Icon(
            CupertinoIcons.back,
            color: Color(0xFF2C3E50),
          ),
        ),
      ),
      child: SafeArea(
        child: Consumer<CartService>(
          builder:  (context, cartService, child) {
            if (cartService.items.isEmpty) {
              return _buildEmptyCart(context);
            }

            return Column(
              children: [
                Expanded(
                  child: ListView. builder(
                    padding: const EdgeInsets.all(16),
                    itemCount:  cartService.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartService.items[index];
                      return _buildCartItem(context, cartService, cartItem);
                    },
                  ),
                ),
                _buildCheckoutSection(context, cartService),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
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
            const SizedBox(height:  8),
            Text(
              'Add some items to get started',
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF666666).withValues(alpha: 0.7),
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 32),
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

  Widget _buildCartItem(
      BuildContext context,
      CartService cartService,
      CartItem cartItem,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:  const Color(0xFF000000).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              cartItem.product.imageUrl,
              width: 80,
              height:  80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80,
                height:  80,
                color: const Color(0xFFE5E7EB),
                child: const Icon(
                  CupertinoIcons.photo,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${cartItem.product.price. toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF8A9A5B),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildQuantityButton(
                      CupertinoIcons.minus,
                          () {
                        if (cartItem.quantity > 1) {
                          cartService.updateQuantity(
                            cartItem. product.id,
                            cartItem.quantity - 1,
                          );
                        }
                      },
                    ),
                    Container(
                      width: 40,
                      alignment: Alignment.center,
                      child: Text(
                        '${cartItem.quantity}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    _buildQuantityButton(
                      CupertinoIcons.plus,
                          () {
                        cartService.updateQuantity(
                          cartItem.product.id,
                          cartItem.quantity + 1,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          CupertinoButton(
            padding: const EdgeInsets.all(8),
            onPressed: () {
              cartService.removeFromCart(cartItem.product. id);
            },
            child: const Icon(
              CupertinoIcons.trash,
              color: CupertinoColors.destructiveRed,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onTap) {
    return CupertinoButton(
      padding:  EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F3F0),
          border: Border.all(
            color: const Color(0xFFD1C4B0),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF8A9A5B),
          size: 16,
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, CartService cartService) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors. white,
        boxShadow: [
          BoxShadow(
            color:  const Color(0xFF000000).withValues(alpha: 0.1),
            blurRadius:  20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                  letterSpacing:  0.3,
                ),
              ),
              Text(
                '\$${cartService.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight. w700,
                  color: Color(0xFF8A9A5B),
                  letterSpacing:  0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // ✅ Navigate to checkout screen instead of showing modal
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.pushNamed(context, '/checkout'), // ✅ Navigate
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF2C3E50),
                borderRadius: BorderRadius. circular(24),
                boxShadow:  [
                  BoxShadow(
                    color: const Color(0xFF000000).withValues(alpha: 0.1),
                    blurRadius:  10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                'CHECKOUT',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF8F5F0),
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentOptions(BuildContext context, CartService cartService) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => PaymentOptionsModal(
        onPaymentSelected: (paymentMethod) =>
            _processPayment(context, cartService, paymentMethod),
      ),
    );
  }

  Future<void> _processPayment( // ✅ Made async
      BuildContext context,
      CartService cartService,
      String paymentMethod,
      ) async {
    final paymentService = Provider.of<PaymentService>(context, listen: false);
    final orderService = OrderService();

    // Show processing
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CupertinoActivityIndicator(radius: 16),
      ),
    );

    // Create order
    final orderId = await orderService.createOrder(
      cartItems: cartService.items,
      total: cartService.total,
      paymentMethod: paymentMethod,
    );

    if (orderId != null) {
      // Process payment
      final success = await paymentService.processPayment(
        amount: cartService.total,
        method: PaymentMethod.visa,
        orderId: orderId,
      );

      if (context.mounted) Navigator.pop(context); // ✅ Close processing

      if (success) {
        cartService.clearCart();

        if (context.mounted) { // ✅ Check if mounted
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text(
                'Order Successful!',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.white,
                  letterSpacing: 0.5,
                ),
              ),
              content:  Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Order #$orderId\nPayment:  $paymentMethod',
                  style: const TextStyle(
                    fontSize:  13,
                    fontWeight: FontWeight.w400,
                    color: CupertinoColors.white,
                    height: 1.4,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF007AFF),
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }
    } else {
      if (context.mounted) Navigator.pop(context); // ✅ Close processing
      // Show error
    }
  }
}