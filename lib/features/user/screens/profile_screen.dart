import 'package:flutter/cupertino.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/user_model.dart';
import '../../../core/routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  UserModel? _userModel;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _authService.currentUser;
    if (user != null) {
      final userModel = await _authService.getUserModel(user. uid);
      setState(() {
        _userModel = userModel;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Profile'),
        backgroundColor: Color(0xFF2C3E50),
        brightness: Brightness.dark,
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(
          child: CupertinoActivityIndicator(),
        )
            : _userModel == null
            ? _buildNotLoggedIn()
            : _buildProfile(),
      ),
    );
  }

  Widget _buildNotLoggedIn() {
    return Center(
      child:  Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment. center,
          children: [
            const Icon(
              CupertinoIcons.person_circle,
              size: 80,
              color: Color(0xFF8A9A5B),
            ),
            const SizedBox(height: 16),
            const Text(
              'Not logged in',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height:  8),
            Text(
              'Sign in to access your account',
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF666666).withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),
            // ✅ Compact button - not full width
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child:  Listener(
                onPointerDown:  (_) {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 48), // ✅ Fixed width
                  decoration: BoxDecoration(
                    color: const Color(0xFF8A9A5B),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF000000).withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF8F5F0),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Profile Header
        Center(
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF8A9A5B).withValues(alpha: 0.2),
                ),
                child: const Icon(
                  CupertinoIcons.person_fill,
                  size: 50,
                  color: Color(0xFF8A9A5B),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _userModel?.displayName ?? 'User',
                style: const TextStyle(
                  fontSize:  24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _userModel?.email ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration:  BoxDecoration(
                  color: _userModel?.isAdmin == true
                      ? const Color(0xFF8A9A5B)
                      : const Color(0xFFC4A484),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:  Text(
                  _userModel?. role. toUpperCase() ?? 'USER',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    color: CupertinoColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Menu Items
        _buildMenuItem(
          icon: CupertinoIcons.person,
          title: 'Edit Profile',
          onTap: () {
            // Navigate to edit profile
          },
        ),
        _buildMenuItem(
          icon: CupertinoIcons.bag,
          title: 'My Orders',
          onTap:  () {
            // Navigate to orders
          },
        ),
        _buildMenuItem(
          icon: CupertinoIcons.heart,
          title: 'Wishlist',
          onTap:  () {
            // Navigate to wishlist
          },
        ),
        _buildMenuItem(
          icon: CupertinoIcons. location,
          title: 'Addresses',
          onTap: () {
            // Navigate to addresses
          },
        ),
        _buildMenuItem(
          icon: CupertinoIcons.settings,
          title: 'Settings',
          onTap: () {
            // Navigate to settings
          },
        ),

        if (_userModel?.isAdmin == true)
          _buildMenuItem(
            icon: CupertinoIcons.square_grid_2x2,
            title: 'Admin Dashboard',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.adminDashboard);
            },
          ),

        const SizedBox(height: 16),

        // Sign Out Button - ✅ Not full width, centered
        Center(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Listener(
              onPointerDown: (_) {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Sign Out'),
                    content: const Text('Are you sure you want to sign out?'),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: const Text('Sign Out'),
                        onPressed: () async {
                          Navigator.pop(context);
                          await _authService.signOut();
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.home,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 32), // ✅ Fixed width
                decoration: BoxDecoration(
                  color: CupertinoColors.destructiveRed,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child:  Listener(
        onPointerDown: (_) => onTap(),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
              Icon(
                icon,
                color: const Color(0xFF8A9A5B),
                size: 22,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ),
              const Icon(
                CupertinoIcons.chevron_right,
                color: Color(0xFF666666),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}