class AppConstants {
  // App Info
  static const String appName = 'ÉCLAT';
  static const String appTagline = 'Curated Luxury Collection';
  static const String appVersion = '1.0.0';

  // Colors (Hex values for reference)
  static const String primaryColorHex = '#2C3E50';
  static const String secondaryColorHex = '#8A9A5B';
  static const String accentColorHex = '#C4A484';
  static const String backgroundColorHex = '#F8F5F0';

  // Default User Credentials
  static const String defaultAdminEmail = 'admin@eclat.com';
  static const String defaultAdminPassword = 'admin123456';
  static const String defaultUserEmail = 'user1@eclat.com';
  static const String defaultUserPassword = 'user123456';

  // User Roles
  static const String roleAdmin = 'admin';
  static const String roleUser = 'user';

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';
  static const String ordersCollection = 'orders';
  static const String categoriesCollection = 'categories';

  // Pagination
  static const int productsPerPage = 20;
  static const int usersPerPage = 50;
  static const int ordersPerPage = 20;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  // UI
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 4.0;

  // Animation Duration
  static const int defaultAnimationDuration = 300;
  static const int slowAnimationDuration = 500;
  static const int fastAnimationDuration = 150;

  // Messages
  static const String errorGeneric = 'An error occurred. Please try again.';
  static const String errorNetwork = 'Network error. Check your connection.';
  static const String errorAuth = 'Authentication failed. Please try again.';
  static const String successLogin = 'Login successful!';
  static const String successRegister = 'Registration successful!';
  static const String successLogout = 'Logged out successfully. ';

  // Placeholder Images
  static const String placeholderProductImage =
      'https://via.placeholder.com/300x400/8A9A5B/FFFFFF?text=Product';
  static const String placeholderUserAvatar =
      'https://via.placeholder.com/100x100/2C3E50/FFFFFF? text=User';

  // Product Categories
  static const List<String> productCategories = [
    'Watches',
    'Bags',
    'Sunglasses',
    'Accessories',
    'Jewelry',
    'Clothing',
  ];

  // Order Status
  static const String orderStatusPending = 'pending';
  static const String orderStatusProcessing = 'processing';
  static const String orderStatusShipped = 'shipped';
  static const String orderStatusDelivered = 'delivered';
  static const String orderStatusCancelled = 'cancelled';

  static const List<String> orderStatuses = [
    orderStatusPending,
    orderStatusProcessing,
    orderStatusShipped,
    orderStatusDelivered,
    orderStatusCancelled,
  ];
}