import 'package:flutter/cupertino.dart';
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
            color:  const Color(0xFF000000).withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            // Logo
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

            // Actions
            Row(
              children:  [
                // Home Icon
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  },
                  child:  const Icon(
                    CupertinoIcons.home,
                    color: Color(0xFFF8F5F0),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 8),

                // Menu Icon
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => _buildMenu(context, authService),
                    );
                  },
                  child:  const Icon(
                    CupertinoIcons.ellipsis_vertical,
                    color:  Color(0xFFF8F5F0),
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
    return CupertinoActionSheet(
      title: const Text('Admin Menu'),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes. adminDashboard);
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.square_grid_2x2, size: 20),
              SizedBox(width: 8),
              Text('Dashboard'),
            ],
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/admin/users');
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.person_2, size: 20),
              SizedBox(width: 8),
              Text('Manage Users'),
            ],
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/admin/products');
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment. center,
            children: [
              Icon(CupertinoIcons.cube_box, size: 20),
              SizedBox(width: 8),
              Text('Manage Products'),
            ],
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          },
          child:  const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.home, size: 20),
              SizedBox(width: 8),
              Text('Back to Store'),
            ],
          ),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed:  () async {
            Navigator.pop(context);
            await authService.signOut();
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            }
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment. center,
            children: [
              Icon(CupertinoIcons.square_arrow_right, size: 20),
              SizedBox(width: 8),
              Text('Sign Out'),
            ],
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
    );
  }
}