import 'package:flutter/cupertino.dart';

class AnalyticsStatGrid extends StatelessWidget {
  final double revenue;
  final int orders;
  final int visitors;
  final String topProduct;

  const AnalyticsStatGrid({
    super.key,
    required this.revenue,
    required this.orders,
    required this.visitors,
    required this.topProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _StatCard(
              title: 'Revenue',
              value: "\$${revenue.toStringAsFixed(0)}",
              icon: CupertinoIcons.money_dollar,
              color: const Color(0xFFC4A484),
            ),
            const SizedBox(width: 16),
            _StatCard(
              title: 'Orders',
              value: orders.toString(),
              icon: CupertinoIcons.bag,
              color: const Color(0xFF8A9A5B),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _StatCard(
              title: 'Visitors',
              value: visitors.toString(),
              icon: CupertinoIcons.person_2_fill,
              color: const Color(0xFF2C3E50),
            ),
            const SizedBox(width: 16),
            _StatCard(
              title: 'Top Product',
              value: topProduct,
              icon: CupertinoIcons.cube_box,
              color: const Color(0xFF8A9A5B),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 88,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        margin: const EdgeInsets.only(bottom: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Color(0xFFF8F5F0), size: 30),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF8F5F0),
                letterSpacing: 1,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: const Color(0xFFF8F5F0).withOpacity(0.7),
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}