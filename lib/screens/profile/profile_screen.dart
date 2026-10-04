import 'package:flutter/material.dart';
import '../../theme.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool pushNotifications = true;
  bool incidentAlerts = true;
  bool locationTracking = true;
  bool autoSOSCountdown = true;
  bool shareWithCommunity = false;

  final List<Map<String, String>> stats = [
    {'label': 'Reports Filed', 'value': '7'},
    {'label': 'Routes Taken', 'value': '34'},
    {'label': 'Trusted Contacts', 'value': '3'},
  ];

  void logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text('Log Out', style: TextStyle(color: AppTheme.textPrimary)),
        content: Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text('Log Out', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            SizedBox(height: 24),
            _buildStatsRow(),
            SizedBox(height: 24),
            _buildSectionTitle('Notifications'),
            SizedBox(height: 8),
            _buildSettingsGroup([
              _buildToggleRow(
                icon: Icons.notifications_outlined,
                label: 'Push Notifications',
                subtitle: 'Receive general app notifications',
                value: pushNotifications,
                onChanged: (v) => setState(() => pushNotifications = v),
              ),
              _buildToggleRow(
                icon: Icons.warning_amber_outlined,
                label: 'Incident Alerts',
                subtitle: 'Get notified of nearby incidents',
                value: incidentAlerts,
                onChanged: (v) => setState(() => incidentAlerts = v),
              ),
            ]),
            SizedBox(height: 20),
            _buildSectionTitle('Privacy & Location'),
            SizedBox(height: 8),
            _buildSettingsGroup([
              _buildToggleRow(
                icon: Icons.location_on_outlined,
                label: 'Location Tracking',
                subtitle: 'Allow background location for safety scoring',
                value: locationTracking,
                onChanged: (v) => setState(() => locationTracking = v),
              ),
              _buildToggleRow(
                icon: Icons.groups_outlined,
                label: 'Share Reports with Community',
                subtitle: 'Your reports help improve area safety scores',
                value: shareWithCommunity,
                onChanged: (v) => setState(() => shareWithCommunity = v),
              ),
            ]),
            SizedBox(height: 20),
            _buildSectionTitle('Emergency Preferences'),
            SizedBox(height: 8),
            _buildSettingsGroup([
              _buildToggleRow(
                icon: Icons.timer_outlined,
                label: 'Auto SOS Countdown',
                subtitle: '10-second countdown before alert sends',
                value: autoSOSCountdown,
                onChanged: (v) => setState(() => autoSOSCountdown = v),
              ),
            ]),
            SizedBox(height: 20),
            _buildSectionTitle('Account'),
            SizedBox(height: 8),
            _buildSettingsGroup([
              _buildLinkRow(icon: Icons.person_outline, label: 'Edit Profile'),
              _buildLinkRow(icon: Icons.lock_outline, label: 'Change Password'),
              _buildLinkRow(icon: Icons.help_outline, label: 'Help & Support'),
              _buildLinkRow(icon: Icons.info_outline, label: 'About SafeSphere'),
            ]),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: logout,
                icon: Icon(Icons.logout, size: 18, color: AppTheme.error),
                label: Text(
                  'Log Out',
                  style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme.error.withOpacity(0.5)),
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.surfaceLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: AppTheme.primary.withOpacity(0.2),
            child: Text('👩', style: TextStyle(fontSize: 32)),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sarah Johnson',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 4),
                Text(
                  'sarah.johnson@email.com',
                  style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Verified Member',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              border: Border.all(color: AppTheme.surfaceLight),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  stat['value']!,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  stat['label']!,
                  style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.surfaceLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final isLast = entry.key == children.length - 1;
          return Column(
            children: [
              entry.value,
              if (!isLast)
                Divider(color: AppTheme.surfaceLight, height: 1, indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildToggleRow({
    required IconData icon,
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textSecondary, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: AppTheme.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildLinkRow({required IconData icon, required String label}) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label coming soon')),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.textSecondary, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 13, color: AppTheme.textPrimary),
              ),
            ),
            Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}