import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCard extends StatelessWidget {
  final String uid;
  final String email;
  final String displayName;
  final String role;
  final VoidCallback? onRoleChanged;

  const UserCard({
    super.key,
    required this.uid,
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
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C3E50).withOpacity(0.08), // Soft shadow
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: role == 'admin'
                  ? const Color(0xFF8A9A5B).withValues(alpha: 51)
                  : const Color(0xFFC4A484).withValues(alpha: 51),
            ),
            child: Icon(
              role == 'admin'
                  ? CupertinoIcons.shield_fill
                  : CupertinoIcons.person_fill,
              color: role == 'admin'
                  ? const Color(0xFF8A9A5B)
                  : const Color(0xFFC4A484),
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
                    fontSize: 12,
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    role.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
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
            child: const Icon(
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
        title: Text(
          displayName,
          style: const TextStyle(
            color: CupertinoColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
          textAlign: TextAlign.center,
        ),
        message: Text(
          email,
          style: const TextStyle(
            color: CupertinoColors.white,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _showUserDetails(context);
            },
            child: const Text(
              'View Details',
              style: TextStyle(color: CupertinoColors.white),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _toggleRole(context);
            },
            child: Text(
              role == 'admin' ? 'Demote to User' : 'Promote to Admin',
              style: const TextStyle(color: CupertinoColors.white),
            ),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              _confirmDelete(context);
            },
            child: const Text(
              'Delete User',
              style: TextStyle(color: CupertinoColors.destructiveRed),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: CupertinoColors.systemGrey),
          ),
        ),
      ),
    );
  }

  void _showUserDetails(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text(
          'User Details',
          style: TextStyle(color: CupertinoColors.white),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text(
              'Name: $displayName',
              style: const TextStyle(color: CupertinoColors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: $email',
              style: const TextStyle(color: CupertinoColors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Role: ${role.toUpperCase()}',
              style: const TextStyle(color: CupertinoColors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'UID: $uid',
              style: const TextStyle(color: CupertinoColors.white),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: CupertinoColors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleRole(BuildContext context) async {
    final newRole = role == 'admin' ? 'user' : 'admin';

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Change Role', style: TextStyle(color: CupertinoColors.white)),
        content: Text(
          "Change $displayName's role to ${newRole.toUpperCase()}?",
          style: const TextStyle(color: CupertinoColors.white),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel', style: TextStyle(color: CupertinoColors.white)),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Confirm', style: TextStyle(color: CupertinoColors.activeGreen)),
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
                      title: const Text('Success', style: TextStyle(color: CupertinoColors.white)),
                      content: Text(
                        'User role changed to ${newRole.toUpperCase()}',
                        style: const TextStyle(color: CupertinoColors.white),
                      ),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('OK', style: TextStyle(color: CupertinoColors.white)),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('Error', style: TextStyle(color: CupertinoColors.destructiveRed)),
                      content: Text(
                        'Failed to change role: $e',
                        style: const TextStyle(color: CupertinoColors.white),
                      ),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('OK', style: TextStyle(color: CupertinoColors.white)),
                          onPressed: () => Navigator.pop(context),
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
        title: const Text('Delete User', style: TextStyle(color: CupertinoColors.destructiveRed)),
        content: Text(
          'Are you sure you want to delete $displayName? This action cannot be undone.',
          style: const TextStyle(color: CupertinoColors.white),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel', style: TextStyle(color: CupertinoColors.white)),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Delete', style: TextStyle(color: CupertinoColors.destructiveRed)),
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .delete();

                if (context.mounted) {
                  Navigator.pop(context);
                  onRoleChanged?.call();

                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('Success', style: TextStyle(color: CupertinoColors.activeGreen)),
                      content: const Text('User deleted successfully', style: TextStyle(color: CupertinoColors.white)),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('OK', style: TextStyle(color: CupertinoColors.white)),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('Error', style: TextStyle(color: CupertinoColors.destructiveRed)),
                      content: Text(
                        'Failed to delete user: $e',
                        style: const TextStyle(color: CupertinoColors.white),
                      ),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('OK', style: TextStyle(color: CupertinoColors.white)),
                          onPressed: () => Navigator.pop(context),
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