import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/services/cart_service.dart';
import '../../../data/services/wishlist_service.dart';
import 'slide_menu.dart';

class HomeNavbar extends StatelessWidget {
  const HomeNavbar({super.key});

  @override
  Widget build(BuildContext context) {
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
            const Text(
              'ÉCLAT',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight. w300,
                letterSpacing: 4,
                color: Color(0xFFF8F5F0),
              ),
            ),

            // Actions
            Row(
              children:  [
                // Wishlist Icon with Badge
                Consumer<WishlistService>(
                  builder: (context, wishlistService, child) {
                    return CupertinoButton(
                      padding: EdgeInsets.zero,
                      pressedOpacity: 0.6,
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.wishlist),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              CupertinoIcons.heart,
                              color: Color(0xFFF8F5F0),
                              size: 24,
                            ),
                            if (wishlistService.itemCount > 0)
                              Positioned(
                                right: 2,
                                top: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEF4444),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF2C3E50),
                                      width: 2,
                                    ),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 18,
                                    minHeight:  18,
                                  ),
                                  child: Text(
                                    '${wishlistService.itemCount}',
                                    style: const TextStyle(
                                      color: Color(0xFFF8F5F0),
                                      fontSize: 10,
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

                // Cart Icon with Badge
                Consumer<CartService>(
                  builder: (context, cartService, child) {
                    return CupertinoButton(
                      padding: EdgeInsets.zero,
                      pressedOpacity: 0.6,
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              CupertinoIcons.cart,
                              color: Color(0xFFF8F5F0),
                              size: 26,
                            ),
                            if (cartService.itemCount > 0)
                              Positioned(
                                right: 2,
                                top: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEF4444),
                                    shape:  BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF2C3E50),
                                      width: 2,
                                    ),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  child: Text(
                                    '${cartService. itemCount}',
                                    style: const TextStyle(
                                      color: Color(0xFFF8F5F0),
                                      fontSize: 10,
                                      fontWeight:  FontWeight.w700,
                                      height: 1.0,
                                    ),
                                    textAlign: TextAlign. center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Menu Icon
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  pressedOpacity: 0.6,
                  onPressed: () => _openSlideMenu(context),
                  child: SizedBox(
                    width:  40,
                    height:  40,
                    child:  Column(
                      mainAxisAlignment:  MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 22,
                          height: 2,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F5F0),
                            borderRadius: BorderRadius. circular(1),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: 22,
                          height: 2,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F5F0),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: 22,
                          height: 2,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F5F0),
                            borderRadius:  BorderRadius.circular(1),
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
        barrierColor:  const Color(0x00000000),
        transitionDuration:  const Duration(milliseconds: 450), // ✅ Slower, smoother
        reverseTransitionDuration: const Duration(milliseconds: 400), // ✅ Smooth close
        pageBuilder: (context, animation, secondaryAnimation) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Animated backdrop
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
                        animation. value * 0.5,
                      ),
                    ),
                  );
                },
              ),

              // Slide menu
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent:  animation,
                    curve:  Curves.easeOutQuart, // ✅ Smoother curve
                    reverseCurve: Curves. easeInQuart, // ✅ Smooth close
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: const SlideMenu(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}