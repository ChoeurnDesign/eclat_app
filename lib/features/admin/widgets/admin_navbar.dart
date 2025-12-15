import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/services/auth_service.dart';
import '../../../core/routes/app_routes.dart';

class AdminNavbar extends StatelessWidget {
  const AdminNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C3E50),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  CupertinoIcons.shield_fill,
                  color: Color(0xFF8A9A5B),
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'ADMIN',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 3,
                    color: Color(0xFFF8F5F0),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  },
                  child: const Icon(
                    CupertinoIcons.home,
                    color: Color(0xFFF8F5F0),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 8),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => _buildMenu(context, authService),
                    );
                  },
                  child: const Icon(
                    CupertinoIcons.ellipsis_vertical,
                    color: Color(0xFFF8F5F0),
                    size: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu(BuildContext context, AuthService authService) {
    TextStyle menuStyle = const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16);

    return CupertinoActionSheet(
      title: Text(
        'Admin Menu',
        style: menuStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
        textAlign: TextAlign.center,
      ),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.adminDashboard);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.square_grid_2x2, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Dashboard', style: menuStyle),
            ],
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/admin/users');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.person_2, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Manage Users', style: menuStyle),
            ],
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/admin/products');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.cube_box, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Manage Products', style: menuStyle),
            ],
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.home, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Back to Store', style: menuStyle),
            ],
          ),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () async {
            Navigator.pop(context);
            await authService.signOut();
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(CupertinoIcons.square_arrow_right, color: Colors.red, size: 20),
              SizedBox(width: 8),
              Text('Sign Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 16)),
            ],
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.pop(context),
        child: Text('Cancel', style: menuStyle),
      ),
    );
  }
}