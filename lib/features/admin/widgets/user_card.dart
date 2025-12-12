import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCard extends StatelessWidget {
  final String uid;
  final String email;
  final String displayName;
  final String role;
  final VoidCallback?  onRoleChanged;

  const UserCard({
    super.key,
    required this. uid,
    required this.email,
    required this.displayName,
    required this.role,
    this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow:  [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width:  50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: role == 'admin'
                  ? const Color(0xFF8A9A5B).withValues(alpha: 0.2)
                  : const Color(0xFFC4A484).withValues(alpha: 0.2),
            ),
            child: Icon(
              role == 'admin' ? CupertinoIcons.shield_fill : CupertinoIcons.person_fill,
              color: role == 'admin' ? const Color(0xFF8A9A5B) : const Color(0xFFC4A484),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize:  12,
                    color: Color(0xFF666666),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: role == 'admin'
                        ? const Color(0xFF8A9A5B)
                        : const Color(0xFFC4A484),
                    borderRadius: BorderRadius. circular(8),
                  ),
                  child: Text(
                    role. toUpperCase(),
                    style: const TextStyle(
                      fontSize:  10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      color: CupertinoColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Actions
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => _showUserActions(context),
            child:  const Icon(
              CupertinoIcons.ellipsis_vertical,
              color: Color(0xFF666666),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  void _showUserActions(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(displayName),
        message: Text(email),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator. pop(context);
              _showUserDetails(context);
            },
            child: const Text('View Details'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _toggleRole(context);
            },
            child: Text(role == 'admin' ?  'Demote to User' : 'Promote to Admin'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              _confirmDelete(context);
            },
            child: const Text('Delete User'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _showUserDetails(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('User Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text('Name: $displayName'),
            const SizedBox(height: 8),
            Text('Email: $email'),
            const SizedBox(height: 8),
            Text('Role: ${role. toUpperCase()}'),
            const SizedBox(height: 8),
            Text('UID: $uid'),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Close'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _toggleRole(BuildContext context) async {
    final newRole = role == 'admin' ? 'user' : 'admin';

    showCupertinoDialog(
      context: context,
      builder:  (context) => CupertinoAlertDialog(
        title:  const Text('Change Role'),
        content: Text('Change $displayName\'s role to ${newRole.toUpperCase()}?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Confirm'),
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .update({'role': newRole});

                if (context.mounted) {
                  Navigator.pop(context);
                  onRoleChanged?.call();

                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('Success'),
                      content: Text('User role changed to ${newRole.toUpperCase()}'),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('OK'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                }
              } catch (e) {
                if (context. mounted) {
                  Navigator. pop(context);
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('Error'),
                      content: Text('Failed to change role: $e'),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('OK'),
                          onPressed:  () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete $displayName?  This action cannot be undone.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    . collection('users')
                    . doc(uid)
                    . delete();

                if (context.mounted) {
                  Navigator.pop(context);
                  onRoleChanged?.call();

                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('Success'),
                      content: const Text('User deleted successfully'),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('OK'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                }
              } catch (e) {
                if (context. mounted) {
                  Navigator. pop(context);
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('Error'),
                      content: Text('Failed to delete user: $e'),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('OK'),
                          onPressed:  () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}