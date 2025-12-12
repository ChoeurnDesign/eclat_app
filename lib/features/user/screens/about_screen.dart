import 'package:flutter/cupertino.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super. key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor:  const Color(0xFFF8F5F0),
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          'About ÉCLAT',
          style: TextStyle(color: Color(0xFF2C3E50)),
        ),
        backgroundColor: const Color(0xFFF8F5F0),
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
            CupertinoIcons.back,
            color: Color(0xFF2C3E50),
          ),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Logo
            Center(
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: const BoxDecoration(
                  color: Color(0xFF2C3E50),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  'É',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFFF8F5F0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Brand Name
            const Center(
              child: Text(
                'ÉCLAT',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 6,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
            const SizedBox(height: 8),

            Center(
              child: Text(
                'Curated Luxury Collection',
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 2,
                  color: const Color(0xFF6B7280).withValues(alpha: 0.8),
                ),
              ),
            ),

            const SizedBox(height:  32),

            // Story
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Story',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'ÉCLAT was founded with a vision to bring timeless elegance and luxury to discerning customers worldwide. Our curated collection features only the finest products, handpicked for quality and style.',
                    style: TextStyle(
                      fontSize:  15,
                      color: Color(0xFF6B7280),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Values
            Container(
              padding:  const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Our Values',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight. w600,
                      color:  Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildValue('Quality', 'We never compromise on excellence'),
                  _buildValue('Sustainability', 'Committed to ethical practices'),
                  _buildValue('Customer Focus', 'Your satisfaction is our priority'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Version
            Center(
              child:  Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF6B7280).withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValue(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF8A9A5B),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height:  2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize:  14,
                    color:  Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}