// Simple animations utility file
class LuxuryAnimations {
  // Animation durations in milliseconds
  static const int fast = 300;
  static const int medium = 500;
  static const int slow = 800;

  // Animation delay options
  static const int noDelay = 0;
  static const int shortDelay = 100;
  static const int mediumDelay = 200;
  static const int longDelay = 300;

  // Animation types
  static const String fadeIn = 'fadeIn';
  static const String slideUp = 'slideUp';
  static const String scaleIn = 'scaleIn';
  static const String slideLeft = 'slideLeft';
  static const String slideRight = 'slideRight';

  // Get animation duration based on type
  static int getDuration(String type) {
    switch (type) {
      case fadeIn:
        return fast;
      case slideUp:
        return medium;
      case scaleIn:
        return medium;
      default:
        return fast;
    }
  }

  // Get delay for staggered animations
  static int getStaggeredDelay(int index, {int baseDelay = 100}) {
    return baseDelay * index;
  }
}