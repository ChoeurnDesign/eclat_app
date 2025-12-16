import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/services/cart_service.dart';
import '../../../data/services/wishlist_service.dart';
import 'slide_menu.dart';

class HomeNavbar extends StatelessWidget {
  final double scrollOffset;

  const HomeNavbar({
    super.key,
    required this.scrollOffset,
  });

  double get _logoOpacity {
    return 1.0 - (scrollOffset / 120).clamp(0, 1);
  }

  double get _textOpacity {
    return (scrollOffset / 150).clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5F0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.1),
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
            // Logo/Text Section
            Expanded(
              child: Container(
                height: 48, // Increased height to accommodate larger text
                alignment: Alignment.centerLeft,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // Logo - JUST THE LETTER "É" - INCREASED SIZE
                    Opacity(
                      opacity: _logoOpacity,
                      child: Container(
                        width: 48, // Increased width
                        height: 48, // Increased height
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'É',
                          style: TextStyle(
                            fontSize: 36, // INCREASED from 28 to 36
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF8A9A5B), // Gold color
                          ),
                        ),
                      ),
                    ),

                    // Text - INCREASED SIZE
                    Opacity(
                      opacity: _textOpacity,
                      child: Container(
                        width: 200, // Increased width for larger text
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'ÉCLAT',
                          style: TextStyle(
                            fontSize: 32, // INCREASED from 26 to 32
                            fontWeight: FontWeight.w300,
                            letterSpacing: 5, // Slightly increased
                            color: Color(0xFF2C3E50),
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Icons - Adjusted spacing for larger text
            Row(
              children: [
                Consumer<WishlistService>(
                  builder: (context, wishlistService, child) {
                    return CupertinoButton(
                      padding: EdgeInsets.zero,
                      pressedOpacity: 0.6,
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.wishlist),
                      child: SizedBox(
                        width: 44, // Slightly larger
                        height: 44,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.heart,
                              color: const Color(0xFF2C3E50),
                              size: 26, // Slightly larger
                            ),
                            if (wishlistService.itemCount > 0)
                              Positioned(
                                right: 2,
                                top: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8A9A5B),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFF8F5F0),
                                      width: 2,
                                    ),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 20, // Slightly larger
                                    minHeight: 20,
                                  ),
                                  child: Text(
                                    '${wishlistService.itemCount}',
                                    style: const TextStyle(
                                      color: Color(0xFFF8F5F0),
                                      fontSize: 11, // Slightly larger
                                      fontWeight: FontWeight.w700,
                                      height: 1.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(width: 8),

                Consumer<CartService>(
                  builder: (context, cartService, child) {
                    return CupertinoButton(
                      padding: EdgeInsets.zero,
                      pressedOpacity: 0.6,
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.cart,
                              color: const Color(0xFF2C3E50),
                              size: 28, // Slightly larger
                            ),
                            if (cartService.itemCount > 0)
                              Positioned(
                                right: 2,
                                top: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8A9A5B),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFF8F5F0),
                                      width: 2,
                                    ),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  child: Text(
                                    '${cartService.itemCount}',
                                    style: const TextStyle(
                                      color: Color(0xFFF8F5F0),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      height: 1.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(width: 8),

                CupertinoButton(
                  padding: EdgeInsets.zero,
                  pressedOpacity: 0.6,
                  onPressed: () => _openSlideMenu(context),
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 24, // Slightly wider
                          height: 2,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C3E50),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 24,
                          height: 2,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C3E50),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 24,
                          height: 2,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C3E50),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openSlideMenu(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: const Color(0x00000000),
        transitionDuration: const Duration(milliseconds: 450),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      color: Color.fromRGBO(
                        0,
                        0,
                        0,
                        animation.value * 0.5,
                      ),
                    ),
                  );
                },
              ),

              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutQuart,
                    reverseCurve: Curves.easeInQuart,
                  ),
                ),
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: SlideMenu(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}