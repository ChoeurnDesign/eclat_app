import 'package:flutter/cupertino.dart';
import '../../../data/services/auth_service.dart';
import '../../../core/routes/app_routes.dart';

class SlideMenu extends StatelessWidget {
  const SlideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final screenWidth = MediaQuery.of(context).size.width;
    final menuWidth = screenWidth * 0.75;

    return Container(
      width: menuWidth,
      height: double.infinity,
      decoration: const BoxDecoration(
        color:  Color(0xFFFAF9F7),
        boxShadow: [
          BoxShadow(
            color:  Color(0x26000000),
            blurRadius:  24,
            offset: Offset(-6, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  const Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight. w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    pressedOpacity: 0.6,
                    onPressed: () => Navigator.pop(context),
                    child: const Icon(
                      CupertinoIcons.xmark,
                      color: Color(0xFF2C3E50),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Content - Scrollable
            Expanded(
              child: StreamBuilder(
                stream: authService.authStateChanges,
                builder: (context, snapshot) {
                  final isLoggedIn = snapshot.data != null;

                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // User Profile Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F3F0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                color: Color(0xFF8A9A5B),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                CupertinoIcons.person_fill,
                                color: Color(0xFFFAF9F7),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isLoggedIn
                                        ? 'Welcome back!'
                                        : 'Welcome to ÉCLAT',
                                    style:  const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color:  Color(0xFF2C3E50),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isLoggedIn
                                        ? 'Manage your account'
                                        : 'Sign in to access your account',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Menu Items
                      _MenuItemCard(
                        icon: CupertinoIcons.home,
                        title: 'Home',
                        subtitle: 'Browse collections',
                        onTap:  () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, AppRoutes.home);
                        },
                      ),

                      _MenuItemCard(
                        icon: CupertinoIcons.cart,
                        title: 'Shopping Cart',
                        subtitle: 'View your items',
                        onTap:  () {
                          Navigator.pop(context);
                          Navigator. pushNamed(context, AppRoutes.cart);
                        },
                      ),

                      _MenuItemCard(
                        icon: CupertinoIcons. heart,
                        title: 'Wishlist',
                        subtitle: 'Saved items',
                        onTap: () {
                          Navigator. pop(context);
                          Navigator.pushNamed(context, AppRoutes.wishlist);
                        },
                      ),

                      _MenuItemCard(
                        icon: CupertinoIcons.bag,
                        title: 'Order History',
                        subtitle:  'View past orders',
                        onTap: () {
                          Navigator. pop(context);
                          Navigator.pushNamed(context, AppRoutes.orderHistory);
                        },
                      ),

                      _MenuItemCard(
                        icon: CupertinoIcons.person,
                        title: 'Profile',
                        subtitle: 'Manage your account',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, AppRoutes.profile);
                        },
                      ),

                      _MenuItemCard(
                        icon: CupertinoIcons.settings,
                        title: 'Settings',
                        subtitle: 'Preferences & privacy',
                        onTap:  () {
                          Navigator.pop(context);
                          Navigator. pushNamed(context, AppRoutes.settings);
                        },
                      ),

                      // ✅ Updated:  Contact Us
                      _MenuItemCard(
                        icon: CupertinoIcons.mail,
                        title: 'Contact Us',
                        subtitle:  'Get in touch',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, AppRoutes.contact);
                        },
                      ),

                      _MenuItemCard(
                        icon: CupertinoIcons. question_circle,
                        title: 'Help & Support',
                        subtitle: 'FAQ & support',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, AppRoutes.help);
                        },
                      ),

                      _MenuItemCard(
                        icon: CupertinoIcons. info_circle,
                        title: 'About ÉCLAT',
                        subtitle: 'Our story & values',
                        onTap:  () {
                          Navigator.pop(context);
                          Navigator. pushNamed(context, AppRoutes.about);
                        },
                      ),

                      // Admin Dashboard (if admin)
                      if (isLoggedIn)
                        FutureBuilder<bool>(
                          future: authService.isAdmin(),
                          builder: (context, snapshot) {
                            if (snapshot.data == true) {
                              return _MenuItemCard(
                                icon:  CupertinoIcons.square_grid_2x2,
                                title: 'Admin Dashboard',
                                subtitle: 'Manage products & orders',
                                onTap:  () {
                                  Navigator. pop(context);
                                  Navigator.pushNamed(
                                      context, AppRoutes.adminDashboard);
                                },
                              );
                            }
                            return const SizedBox. shrink();
                          },
                        ),

                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),

            // Fixed Bottom Button Area
            StreamBuilder(
              stream: authService.authStateChanges,
              builder:  (context, snapshot) {
                final isLoggedIn = snapshot. data != null;

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFAF9F7),
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                  ),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    pressedOpacity:  0.6,
                    onPressed: () async {
                      Navigator.pop(context);
                      if (isLoggedIn) {
                        await authService.signOut();
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.home);
                        }
                      } else {
                        Navigator.pushNamed(context, AppRoutes. login);
                      }
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: isLoggedIn
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF8A9A5B),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        isLoggedIn ? 'Sign Out' : 'Sign In',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFAF9F7),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuItemCard({
    required this.icon,
    required this.title,
    required this. subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        pressedOpacity: 0.6,
        onPressed: onTap,
        child:  Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color:  Color(0xFFFAF9F7),
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFE5E7EB),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children:  [
              Icon(
                icon,
                size: 24,
                color: const Color(0xFF6B7280),
              ),
              const SizedBox(width:  16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:  const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style:  const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                CupertinoIcons.chevron_right,
                size: 18,
                color: Color(0xFFD1D5DB),
              ),
            ],
          ),
        ),
      ),
    );
  }
}