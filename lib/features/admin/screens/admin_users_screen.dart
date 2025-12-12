import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/user_card.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _filter = 'all'; // all, admin, user

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: Color(0xFF2C3E50),
        brightness: Brightness.dark,
        middle: Text(
          'Manage Users',
          style: TextStyle(color: Color(0xFFF8F5F0)),
        ),
      ),
      child: SafeArea(
        child: Column(
          children:  [
            // Filter Tabs
            Container(
              padding: const EdgeInsets.all(16),
              child: CupertinoSlidingSegmentedControl<String>(
                groupValue: _filter,
                backgroundColor: const Color(0xFFF8F5F0),
                thumbColor: const Color(0xFF8A9A5B),
                children: const {
                  'all':  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('All'),
                  ),
                  'admin': Padding(
                    padding: EdgeInsets. symmetric(horizontal: 20),
                    child: Text('Admins'),
                  ),
                  'user': Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Users'),
                  ),
                },
                onValueChanged: (value) {
                  setState(() {
                    _filter = value ??  'all';
                  });
                },
              ),
            ),

            // Users List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getUsersStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }

                  final users = snapshot.data!.docs;

                  if (users.isEmpty) {
                    return const Center(
                      child: Text('No users found'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final userData =
                      users[index].data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child:  UserCard(
                          uid:  userData['uid'] ?? '',
                          email: userData['email'] ??  '',
                          displayName: userData['displayName'] ?? '',
                          role: userData['role'] ??  'user',
                          onRoleChanged: () {
                            setState(() {});
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _getUsersStream() {
    Query query = _firestore.collection('users').orderBy('createdAt', descending: true);

    if (_filter != 'all') {
      query = query.where('role', isEqualTo: _filter);
    }

    return query.snapshots();
  }
}