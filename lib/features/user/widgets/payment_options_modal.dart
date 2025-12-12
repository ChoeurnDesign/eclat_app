import 'package:flutter/cupertino.dart';

class PaymentOptionsModal extends StatelessWidget {
  final Function(String) onPaymentSelected;

  const PaymentOptionsModal({super.key, required this.onPaymentSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color:  Color(0xFFF8F5F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color:  CupertinoColors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Payment Method',
                  style:  TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                    letterSpacing: 0.3,
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.pop(context),
                  child: const Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color: Color(0xFF6B7280),
                    size: 28,
                  ),
                ),
              ],
            ),
          ),

          // Payment Options
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildPaymentOption(
                  context,
                  'Visa / Mastercard',
                  CupertinoIcons.creditcard,
                  'Credit or Debit Card',
                ),
                _buildPaymentOption(
                  context,
                  'PayPal',
                  CupertinoIcons.money_dollar_circle,
                  'Pay with PayPal',
                ),
                _buildPaymentOption(
                  context,
                  'ABA Bank',
                  CupertinoIcons.building_2_fill,
                  'ABA Mobile / KHQR',
                ),
                _buildPaymentOption(
                  context,
                  'ACLEDA Bank',
                  CupertinoIcons.building_2_fill,
                  'ACLEDA Mobile / KHQR',
                ),
                _buildPaymentOption(
                  context,
                  'Wing',
                  CupertinoIcons.device_phone_portrait,
                  'Wing Money',
                ),
                _buildPaymentOption(
                  context,
                  'Cash on Delivery',
                  CupertinoIcons.money_dollar,
                  'Pay when you receive',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
      BuildContext context,
      String title,
      IconData icon,
      String subtitle,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.pop(context);
          onPaymentSelected(title);
        },
        child:  Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width:  1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height:  48,
                decoration: BoxDecoration(
                  color:  const Color(0xFF8A9A5B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF8A9A5B),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment:  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight. w600,
                        color:  Color(0xFF2C3E50),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style:  TextStyle(
                        fontSize: 13,
                        color: const Color(0xFF6B7280).withValues(alpha: 0.8),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                CupertinoIcons.chevron_right,
                color:  Color(0xFF9CA3AF),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}