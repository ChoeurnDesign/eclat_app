import 'package:flutter/cupertino.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      {
        'id': '#12345',
        'date': 'Dec 10, 2025',
        'total': 758.00,
        'status': 'Delivered',
        'items': 2,
      },
      {
        'id': '#12344',
        'date': 'Dec 5, 2025',
        'total': 299.00,
        'status':  'Shipped',
        'items': 1,
      },
    ];

    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          'Order History',
          style: TextStyle(color: Color(0xFF2C3E50)),
        ),
        backgroundColor:  const Color(0xFFF8F5F0),
        border: const Border(
          bottom:  BorderSide(
            color:  Color(0xFFE5E7EB),
            width:  1,
          ),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: const Icon(
            CupertinoIcons.back,
            color: Color(0xFF2C3E50), // ✅ Black back button
          ),
        ),
      ),
      child: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors. white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000).withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order ${order['id']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight. w600,
                          color:  Color(0xFF2C3E50),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: order['status'] == 'Delivered'
                              ? const Color(0xFF10B981).withValues(alpha: 0.1)
                              : const Color(0xFF3B82F6).withValues(alpha: 0.1),
                          borderRadius: BorderRadius. circular(12),
                        ),
                        child: Text(
                          order['status'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: order['status'] == 'Delivered'
                                ? const Color(0xFF10B981)
                                : const Color(0xFF3B82F6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    order['date'] as String,
                    style:  const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${order['items']} items',
                        style: const TextStyle(
                          fontSize:  14,
                          color:  Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        '\$${(order['total'] as double).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize:  16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF8A9A5B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}