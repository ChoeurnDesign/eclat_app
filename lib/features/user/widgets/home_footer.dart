import 'package:flutter/cupertino.dart';
import '../../../core/routes/app_routes.dart';

class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF2C3E50),
        boxShadow: [
          BoxShadow(
            color:   const Color(0xFF000000).withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 20),
        child: Column(
          children: [
            // Main Content
            isDesktop
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildBrandColumn()),
                const SizedBox(width: 48),
                Expanded(child: _buildQuickLinksColumn(context)),
                const SizedBox(width: 48),
                Expanded(child: _buildContactColumn(context)),
              ],
            )
                : Column(
              crossAxisAlignment:   CrossAxisAlignment.start,
              children: [
                _buildBrandColumn(),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment:   CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildQuickLinksColumn(context)),
                    const SizedBox(width: 24),
                    Expanded(child: _buildContactColumn(context)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Divider
            Container(
              height: 1,
              color:  const Color(0xFFF8F5F0).withValues(alpha: 0.1),
            ),

            const SizedBox(height: 16),

            // Bottom Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Text(
                  '© ${DateTime.now().year} ÉCLAT.  All rights reserved.',
                  style: TextStyle(
                    fontSize:  11, // ✅ Increased from 10
                    color: const Color(0xFFF8F5F0).withValues(alpha: 0.5),
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Developed by Choeurn & Vannak',
                  style: TextStyle(
                    fontSize: 11, // ✅ Increased from 10
                    color:  const Color(0xFF8A9A5B).withValues(alpha: 0.8),
                    letterSpacing:   0.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Brand Column
  Widget _buildBrandColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ÉCLAT',
          style: TextStyle(
            fontSize: 26, // ✅ Increased from 24
            fontWeight: FontWeight.w300,
            letterSpacing: 6,
            color: Color(0xFFF8F5F0),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 50,
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF8A9A5B),
                const Color(0xFF8A9A5B).withValues(alpha: 0.3),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Curated luxury fashion collection for the modern individual.   Experience timeless elegance and exceptional quality.',
          style: TextStyle(
            fontSize: 13, // ✅ Increased from 12
            height: 1.5, // ✅ Better line height
            color: const Color(0xFFF8F5F0).withValues(alpha: 0.65),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  // Quick Links Column
  Widget _buildQuickLinksColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'QUICK LINKS',
          style:   TextStyle(
            fontSize:  12, // ✅ Increased from 11
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: Color(0xFF8A9A5B),
          ),
        ),
        const SizedBox(height: 14), // ✅ Increased from 12
        _buildFooterLink(
          'Home',
              () => Navigator.pushNamed(context, AppRoutes.home),
        ),
        _buildFooterLink(
          'About',
              () => Navigator.pushNamed(context, AppRoutes.about),
        ),
        _buildFooterLink(
          'Contact',
              () => Navigator.pushNamed(context, AppRoutes.contact),
        ),
        _buildFooterLink(
          'Help',
              () => Navigator.pushNamed(context, AppRoutes.help),
        ),
      ],
    );
  }

  // Contact Column
  Widget _buildContactColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.  start,
      children: [
        const Text(
          'GET IN TOUCH',
          style:   TextStyle(
            fontSize:  12, // ✅ Increased from 11
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: Color(0xFF8A9A5B),
          ),
        ),
        const SizedBox(height: 14), // ✅ Increased from 12
        _buildContactItem(
          CupertinoIcons.mail,
          'support@eclat.com',
              () => Navigator.pushNamed(context, AppRoutes.contact),
        ),
        const SizedBox(height: 10), // ✅ Increased from 8
        _buildContactItem(
          CupertinoIcons.phone,
          '+855 70 229 710',
              () => Navigator.pushNamed(context, AppRoutes.contact),
        ),
        const SizedBox(height: 10), // ✅ Increased from 8
        _buildContactItem(
          CupertinoIcons.  location,
          'Cambodia',
              () => Navigator.pushNamed(context, AppRoutes.contact),
        ),
        const SizedBox(height: 14), // ✅ Increased from 12
        CupertinoButton(
          padding: EdgeInsets.  zero,
          pressedOpacity: 0.7,
          onPressed: () => Navigator.pushNamed(context, AppRoutes.  contact),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9), // ✅ Increased
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF8A9A5B).withValues(alpha: 0.5),
                width: 1.5,
              ),
              borderRadius: BorderRadius.  circular(24),
            ),
            child: Text(
              'Contact Us',
              style:   TextStyle(
                fontSize:  12, // ✅ Increased from 11
                fontWeight:  FontWeight.w500,
                color: const Color(0xFFF8F5F0).withValues(alpha: 0.9),
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLink(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10), // ✅ Increased from 8
      child: CupertinoButton(
        padding:  EdgeInsets.zero,
        pressedOpacity: 0.7,
        onPressed: onTap,
        child:   Row(
          mainAxisSize:  MainAxisSize.min,
          children: [
            Text(
              text,
              style:  TextStyle(
                fontSize: 14, // ✅ Increased from 13
                color: const Color(0xFFF8F5F0).withValues(alpha: 0.75),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              CupertinoIcons.chevron_right,
              size: 12, // ✅ Increased from 11
              color: const Color(0xFF8A9A5B).withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text, VoidCallback onTap) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      pressedOpacity: 0.7,
      onPressed: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size:  16, // ✅ Increased from 15
            color:  const Color(0xFF8A9A5B),
          ),
          const SizedBox(width:  12), // ✅ Increased from 10
          Expanded(
            child: Text(
              text,
              style:  TextStyle(
                fontSize: 13, // ✅ Increased from 12
                color: const Color(0xFFF8F5F0).withValues(alpha: 0.7),
                letterSpacing:   0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}