import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'analytics_stat_grid.dart';
import 'sales_chart.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
  bool _loading = true;
  double _revenue = 0;
  int _orders = 0;
  int _visitors = 0;
  String _topProduct = '';
  List<SalesData> _salesData = [];

  @override
  void initState() {
    super.initState();
    _fetchAnalytics();
  }

  Future<void> _fetchAnalytics() async {
    final ordersSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .orderBy('createdAt', descending: false)
        .get();

    final usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .get();

    double totalRevenue = 0;
    int ordersCount = ordersSnapshot.size;
    Map<String, int> productCount = {};

    // Build sales chart data for the last 7 days
    DateTime now = DateTime.now();
    Map<String, double> dailyTotals = {};
    for (int i = 6; i >= 0; i--) {
      DateTime day = now.subtract(Duration(days: i));
      String key = "${day.year}-${day.month}-${day.day}";
      dailyTotals[key] = 0;
    }

    for (var doc in ordersSnapshot.docs) {
      final data = doc.data();
      final double orderTotal = (data['total'] ?? 0).toDouble();
      totalRevenue += orderTotal;

      // For daily chart
      if (data['createdAt'] != null) {
        final raw = data['createdAt'];
        late DateTime created;
        if (raw is String) {
          created = DateTime.parse(raw);
        } else if (raw is Timestamp) {
          created = raw.toDate();
        } else {
          created = DateTime.now();
        }
        String key = "${created.year}-${created.month}-${created.day}";
        if (dailyTotals.containsKey(key)) {
          dailyTotals[key] = (dailyTotals[key] ?? 0) + orderTotal;
        }
      }

      // For top product
      if (data['items'] != null) {
        for (var item in List<Map<String, dynamic>>.from(data['items'])) {
          final name = item['productName'] ?? "";
          // robust quantity handling
          int qty = 1;
          if (item['quantity'] is int) {
            qty = item['quantity'] as int;
          } else if (item['quantity'] is double) {
            qty = (item['quantity'] as double).toInt();
          } else if (item['quantity'] != null) {
            qty = int.tryParse(item['quantity'].toString()) ?? 1;
          }
          productCount[name] = (productCount[name] ?? 0) + qty;
        }
      }
    }

    // Find top product
    String topProduct = '';
    int topCount = 0;
    productCount.forEach((name, count) {
      if (count > topCount) {
        topCount = count;
        topProduct = name;
      }
    });

    // Prepare chart data
    final salesData = dailyTotals.entries.map((e) {
      final split = e.key.split('-');
      return SalesData(
        label: "${split[1]}/${split[2]}",
        value: e.value,
      );
    }).toList();

    setState(() {
      _revenue = totalRevenue;
      _orders = ordersCount;
      _visitors = usersSnapshot.size;
      _topProduct = topProduct.isNotEmpty ? topProduct : '--';
      _salesData = salesData;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Analytics", style: TextStyle(color: Color(0xFF2C3E50), fontWeight: FontWeight.bold, letterSpacing: 1)),
        backgroundColor: Color(0xFFF8F5F0),
      ),
      child: SafeArea(
        child: _loading
            ? const Center(child: CupertinoActivityIndicator())
            : CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "OVERVIEW",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                        color: Color(0xFF8A9A5B),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "See stats and performance for your store.",
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            // Stats section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                child: AnalyticsStatGrid(
                  revenue: _revenue,
                  orders: _orders,
                  visitors: _visitors,
                  topProduct: _topProduct,
                ),
              ),
            ),
            // Chart section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "SALES CHART (7 days)",
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 3,
                        color: Color(0xFF8A9A5B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SalesChart(data: _salesData),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

// For chart widget
class SalesData {
  final String label;
  final double value;

  SalesData({required this.label, required this.value});
}