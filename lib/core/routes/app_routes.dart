import 'package:flutter/cupertino.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/user/screens/home_screen.dart';
import '../../features/user/screens/cart_screen.dart';
import '../../features/user/screens/profile_screen.dart';
import '../../features/user/screens/wishlist_screen.dart';
import '../../features/user/screens/order_history_screen.dart';
import '../../features/user/screens/settings_screen.dart';
import '../../features/user/screens/help_screen.dart';
import '../../features/user/screens/about_screen.dart';
import '../../features/user/screens/checkout_screen.dart';
import '../../features/user/screens/contact_screen.dart';
import '../../features/admin/screens/admin_dashboard_screen.dart';
import '../../features/admin/screens/admin_products_screen.dart';
import '../../features/admin/screens/admin_users_screen.dart';
import '../../features/admin/screens/admin_add_edit_product_screen.dart';
import '../../data/models/product_model.dart';

class AppRoutes {
  AppRoutes._();

  // Auth Routes
  static const String login = '/login';
  static const String register = '/register';

  // User Routes
  static const String home = '/';
  static const String cart = '/cart';
  static const String profile = '/profile';
  static const String wishlist = '/wishlist';
  static const String orderHistory = '/order-history';
  static const String settings = '/settings';
  static const String help = '/help';
  static const String about = '/about';
  static const String contact = '/contact'; // ✅ Added
  static const String checkout = '/checkout';

  // Admin Routes
  static const String adminDashboard = '/admin';
  static const String adminUsers = '/admin/users';
  static const String adminProducts = '/admin/products';
  static const String adminAddProduct = '/admin/products/add';
  static const String adminEditProduct = '/admin/products/edit';

  static Map<String, WidgetBuilder> get routes => {
    // Auth
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),

    // User
    home: (context) => const HomeScreen(),
    cart: (context) => const CartScreen(),
    profile: (context) => const ProfileScreen(),
    wishlist: (context) => const WishlistScreen(),
    orderHistory: (context) => const OrderHistoryScreen(),
    settings: (context) => const SettingsScreen(),
    help: (context) => const HelpScreen(),
    about: (context) => const AboutScreen(),
    contact: (context) => const ContactScreen(), // ✅ Added
    checkout: (context) => const CheckoutScreen(),

    // Admin
    adminDashboard: (context) => const AdminDashboardScreen(),
    adminUsers: (context) => const AdminUsersScreen(),
    adminProducts:  (context) => const AdminProductsScreen(),
    adminAddProduct:  (context) => const AdminAddEditProductScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case adminEditProduct:
        final product = settings.arguments as Product? ;
        return CupertinoPageRoute(
          builder: (context) => AdminAddEditProductScreen(product: product),
          settings: settings,
        );

      default:
        final builder = routes[settings.name];
        if (builder != null) {
          return CupertinoPageRoute(
            builder: builder,
            settings: settings,
          );
        }

        return CupertinoPageRoute(
          builder: (context) => _buildErrorPage(settings.name),
          settings: settings,
        );
    }
  }

  static Widget _buildErrorPage(String?  routeName) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Error'),
      ),
      child: Center(
        child:  Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                CupertinoIcons.exclamationmark_triangle,
                size: 64,
                color: CupertinoColors.destructiveRed,
              ),
              const SizedBox(height: 16),
              const Text(
                'Page Not Found',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height:  8),
              Text(
                'Route: ${routeName ?? "unknown"}',
                style: const TextStyle(
                  fontSize:  14,
                  color: CupertinoColors.systemGrey,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, home);
  }

  static void navigateToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, login);
  }

  static void navigateToCart(BuildContext context) {
    Navigator.pushNamed(context, cart);
  }

  static void navigateToCheckout(BuildContext context) {
    Navigator.pushNamed(context, checkout);
  }

  static void navigateToContact(BuildContext context) { // ✅ Added
    Navigator.pushNamed(context, contact);
  }

  static void navigateToEditProduct(BuildContext context, Product product) {
    Navigator.pushNamed(
      context,
      adminEditProduct,
      arguments: product,
    );
  }
}