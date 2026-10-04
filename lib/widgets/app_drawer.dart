import 'package:flutter/material.dart';

import '../screens/circle/trusted_circle_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/reports/reports_screen.dart';
import '../theme.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  void _open(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: (MediaQuery.sizeOf(context).width * 0.82).clamp(290.0, 360.0),
      backgroundColor: const Color(0xFF06111F),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 16),
          children: [
            const Center(child: _DrawerLogo()),
            const SizedBox(height: 10),
            const Center(child: Text('SafeSphere', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
            const SizedBox(height: 3),
            const Center(child: Text('Your Safety, Our Priority', style: TextStyle(color: AppTheme.textSecondary, fontSize: 10))),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.surface.withOpacity(0.9), borderRadius: BorderRadius.circular(15), border: Border.all(color: AppTheme.primary.withOpacity(0.2))),
              child: Row(
                children: [
                  const _DrawerAvatar(),
                  const SizedBox(width: 11),
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Aditya', style: TextStyle(fontWeight: FontWeight.w700)), SizedBox(height: 3), Text('aditya@example.com', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppTheme.textSecondary, fontSize: 10))])),
                  IconButton(onPressed: () => _open(context, ProfileScreen()), icon: const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 22),
            _section('MAIN'),
            _item(context, Icons.person_outline_rounded, 'My Profile', () => _open(context, ProfileScreen())),
            _item(context, Icons.people_outline_rounded, 'Trusted Circle', () => _open(context, TrustedCircleScreen())),
            _item(context, Icons.description_outlined, 'My Reports', () => _open(context, const ReportsScreen())),
            const SizedBox(height: 14),
            _section('SAFETY'),
            _item(context, Icons.shield_outlined, 'Safety Center', () => _message(context, 'Safety Center is up to date.')),
            _item(context, Icons.bookmark_border_rounded, 'Saved Places', () => _message(context, 'Saved places will appear here.')),
            _item(context, Icons.phone_outlined, 'Emergency Contacts', () => _open(context, TrustedCircleScreen())),
            const SizedBox(height: 14),
            _section('SUPPORT'),
            _item(context, Icons.settings_outlined, 'Settings', () => _open(context, ProfileScreen())),
            _item(context, Icons.help_outline_rounded, 'Help & Support', () => _message(context, 'Help and support is coming soon.')),
            const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),
            _item(context, Icons.logout_rounded, 'Logout', () => _message(context, 'Logout will be connected to authentication.'), color: AppTheme.error),
            const SizedBox(height: 16),
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.info_outline_rounded, color: AppTheme.textSecondary, size: 14), SizedBox(width: 6), Text('SafeSphere v1.0.0', style: TextStyle(color: AppTheme.textSecondary, fontSize: 10))]),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) => Padding(padding: const EdgeInsets.only(bottom: 5, left: 4), child: Text(title, style: const TextStyle(color: AppTheme.primary, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.7)));

  Widget _item(BuildContext context, IconData icon, String label, VoidCallback onTap, {Color? color}) {
    final itemColor = color ?? AppTheme.textPrimary;
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      visualDensity: const VisualDensity(vertical: -1),
      leading: Icon(icon, color: color ?? AppTheme.circleTeal, size: 21),
      title: Text(label, style: TextStyle(color: itemColor, fontSize: 13, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary, size: 18),
      onTap: onTap,
    );
  }

  void _message(BuildContext context, String text) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class _DrawerLogo extends StatelessWidget {
  const _DrawerLogo();
  @override
  Widget build(BuildContext context) => Container(width: 56, height: 56, decoration: BoxDecoration(shape: BoxShape.circle, gradient: AppTheme.shieldGradient, boxShadow: AppTheme.glow(AppTheme.primary, blur: 22)), child: const Icon(Icons.shield_rounded, color: Colors.white, size: 30));
}

class _DrawerAvatar extends StatelessWidget {
  const _DrawerAvatar();
  @override
  Widget build(BuildContext context) => Container(width: 42, height: 42, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [Color(0xFF6BE5F6), Color(0xFF193566)]), border: Border.all(color: AppTheme.circleTeal.withOpacity(0.8))), child: const Center(child: Text('A', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17))));
}
