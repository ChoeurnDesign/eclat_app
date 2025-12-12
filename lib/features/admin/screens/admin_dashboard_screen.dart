import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/services/auth_service.dart';
import '../../../core/routes/app_routes.dart';
import '../widgets/admin_navbar.dart';
import '../widgets/user_card.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  bool _isAdmin = false;
  int _totalUsers = 0;
  int _totalAdmins = 0;
  int _totalRegularUsers = 0;

  @override
  void initState() {
    super.initState();
    _checkAdminAndLoadData();
  }

  Future<void> _checkAdminAndLoadData() async {
    final isAdmin = await _authService.isAdmin();
    if (! isAdmin && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
      return;
    }

    setState(() {
      _isAdmin = true;
    });

    await _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    try {
      final usersSnapshot = await _firestore. collection('users').get();
      final adminCount = usersSnapshot.docs
          .where((doc) => doc. data()['role'] == 'admin')
          .length;
      final userCount = usersSnapshot.docs
          .where((doc) => doc.data()['role'] == 'user')
          .length;

      setState(() {
        _totalUsers = usersSnapshot.docs. length;
        _totalAdmins = adminCount;
        _totalRegularUsers = userCount;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (! _isAdmin) {
      return const CupertinoPageScaffold(
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }

    return CupertinoPageScaffold(
      child: Column(
        children: [
          const AdminNavbar(),
          Expanded(
            child: _isLoading
                ? const Center(child: CupertinoActivityIndicator())
                : CustomScrollView(
              slivers: [
                // Welcome Section
                SliverToBoxAdapter(
                  child:  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF2C3E50),
                          Color(0xFF8A9A5B),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ADMIN DASHBOARD',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight:  FontWeight.w300,
                              letterSpacing: 4,
                              color: Color(0xFFF8F5F0),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Manage your ÉCLAT store',
                            style: TextStyle(
                              fontSize:  14,
                              color: const Color(0xFFF8F5F0)
                                  .withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Statistics Cards
                SliverToBoxAdapter(
                  child:  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'OVERVIEW',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:  FontWeight.w500,
                            letterSpacing: 3,
                            color: Color(0xFF8A9A5B),
                          ),
                        ),
                        const SizedBox(height:  16),
                        Row(
                          children: [
                            Expanded(
                              child:  _StatCard(
                                title: 'Total Users',
                                value: '$_totalUsers',
                                icon: CupertinoIcons. person_2,
                                color: const Color(0xFF2C3E50),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                title: 'Admins',
                                value: '$_totalAdmins',
                                icon: CupertinoIcons.shield,
                                color: const Color(0xFF8A9A5B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                title: 'Regular Users',
                                value: '$_totalRegularUsers',
                                icon: CupertinoIcons.person,
                                color: const Color(0xFFC4A484),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                title: 'Products',
                                value: '24',
                                icon: CupertinoIcons.bag,
                                color: const Color(0xFF34495E),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Quick Actions
                SliverToBoxAdapter(
                  child:  Padding(
                    padding:  const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'QUICK ACTIONS',
                          style: TextStyle(
                            fontSize:  12,
                            fontWeight: FontWeight.w500,
                            letterSpacing:  3,
                            color: Color(0xFF8A9A5B),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _ActionButton(
                          icon: CupertinoIcons. person_2,
                          title: 'Manage Users',
                          subtitle: 'View and manage all users',
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/admin/users',
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _ActionButton(
                          icon: CupertinoIcons.cube_box,
                          title: 'Manage Products',
                          subtitle:  'Add, edit, or remove products',
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/admin/products',
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _ActionButton(
                          icon: CupertinoIcons.chart_bar,
                          title:  'View Analytics',
                          subtitle: 'Sales and performance data',
                          onTap:  () {
                            // Navigate to analytics
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Recent Users
                SliverToBoxAdapter(
                  child:  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'RECENT USERS',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 3,
                                color: Color(0xFF8A9A5B),
                              ),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed:  () {
                                Navigator.pushNamed(
                                  context,
                                  '/admin/users',
                                );
                              },
                              child: const Text(
                                'View All',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF8A9A5B),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                // Users List
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('users')
                      .orderBy('createdAt', descending: true)
                      .limit(5)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Text('Error: ${snapshot.error}'),
                        ),
                      );
                    }

                    if (! snapshot.hasData) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      );
                    }

                    final users = snapshot.data!.docs;

                    if (users.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child:  Padding(
                            padding:  EdgeInsets.all(32),
                            child: Text('No users found'),
                          ),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding:  const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final userData =
                            users[index]. data() as Map<String, dynamic>;
                            return Padding(
                              padding:  const EdgeInsets.only(bottom: 12),
                              child: UserCard(
                                uid: userData['uid'] ?? '',
                                email:  userData['email'] ?? '',
                                displayName: userData['displayName'] ??  '',
                                role: userData['role'] ?? 'user',
                              ),
                            );
                          },
                          childCount:  users.length,
                        ),
                      ),
                    );
                  },
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this. icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius. circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFFF8F5F0),
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFFF8F5F0),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFFF8F5F0).withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF8A9A5B).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child:  Icon(
                icon,
                color: const Color(0xFF8A9A5B),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              color: Color(0xFF666666),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}