import 'package:flutter/foundation.dart';

enum PaymentMethod {
  visa,
  paypal,
  aba,
  acleda,
  wing,
  cashOnDelivery,
}

class PaymentService extends ChangeNotifier {
  PaymentMethod?  _selectedMethod;
  bool _isProcessing = false;

  PaymentMethod?  get selectedMethod => _selectedMethod;
  bool get isProcessing => _isProcessing;

  void selectPaymentMethod(PaymentMethod method) {
    _selectedMethod = method;
    notifyListeners();
  }

  /// ✅ This simulates payment processing
  /// In production, integrate with real payment gateways:
  /// - Stripe:  https://pub.dev/packages/flutter_stripe
  /// - PayPal: https://pub.dev/packages/flutter_paypal
  /// - ABA PayWay: Custom API integration
  Future<bool> processPayment({
    required double amount,
    required PaymentMethod method,
    required String orderId,
  }) async {
    _isProcessing = true;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Replace with real payment gateway API
      // Example for Stripe:
      // final paymentIntent = await Stripe.instance.createPaymentMethod(... );
      // final confirmed = await Stripe.instance.confirmPayment(... );

      // Simulate success
      _isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isProcessing = false;
      notifyListeners();
      debugPrint('Payment error: $e');
      return false;
    }
  }

  void reset() {
    _selectedMethod = null;
    _isProcessing = false;
    notifyListeners();
  }
}