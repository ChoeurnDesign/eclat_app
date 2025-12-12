import 'package:flutter/cupertino.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          'Help & Support',
          style: TextStyle(color: Color(0xFF2C3E50)),
        ),
        backgroundColor:  const Color(0xFFF8F5F0),
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: const Icon(
            CupertinoIcons. back,
            color: Color(0xFF2C3E50),
          ),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildFAQItem(
              'How do I track my order?',
              'Go to Order History to view tracking details for all your orders.',
            ),
            _buildFAQItem(
              'What is your return policy?',
              'We offer 30-day returns on all items. Items must be unused and in original packaging.',
            ),
            _buildFAQItem(
              'How long does shipping take?',
              'Standard shipping takes 5-7 business days. Express shipping is 2-3 days.',
            ),
            _buildFAQItem(
              'Do you ship internationally?',
              'Yes!  We ship to over 50 countries worldwide.',
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF8A9A5B).withValues(alpha: 0.1),
                borderRadius: BorderRadius. circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Still need help?',
                    style:  TextStyle(
                      fontSize:  18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Contact our support team',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    color: const Color(0xFF8A9A5B),
                    borderRadius: BorderRadius.circular(24),
                    onPressed: () {},
                    child: const Text(
                      'Contact Support',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFF8F5F0),
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

  Widget _buildFAQItem(String question, String answer) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style:  const TextStyle(
              fontSize:  14,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}