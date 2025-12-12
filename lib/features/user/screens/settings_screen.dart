import 'package:flutter/cupertino.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailUpdates = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          'Settings',
          style: TextStyle(color: Color(0xFF2C3E50)),
        ),
        backgroundColor: const Color(0xFFF8F5F0),
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: const Icon(
            CupertinoIcons. back,
            color: Color(0xFF2C3E50),
          ),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection(
              'Notifications',
              [
                _buildSwitchTile(
                  'Push Notifications',
                  'Receive order updates',
                  _notificationsEnabled,
                      (value) => setState(() => _notificationsEnabled = value),
                ),
                _buildSwitchTile(
                  'Email Updates',
                  'Promotional emails',
                  _emailUpdates,
                      (value) => setState(() => _emailUpdates = value),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Privacy',
              [
                _buildTile('Privacy Policy', () {}),
                _buildTile('Terms of Service', () {}),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Account',
              [
                _buildTile('Change Password', () {}),
                _buildTile('Delete Account', () {}, isDestructive: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title. toUpperCase(),
            style:  const TextStyle(
              fontSize:  12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8A9A5B),
              letterSpacing: 1,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
      String title,
      String subtitle,
      bool value,
      Function(bool) onChanged,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:  const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height:  2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize:  13,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged:  onChanged,
            activeTrackColor: const Color(0xFF8A9A5B), // ✅ Changed from activeColor
          ),
        ],
      ),
    );
  }

  Widget _buildTile(String title, VoidCallback onTap, {bool isDestructive = false}) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          border:  Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF2C3E50),
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              size: 18,
              color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFFD1D5DB),
            ),
          ],
        ),
      ),
    );
  }
}