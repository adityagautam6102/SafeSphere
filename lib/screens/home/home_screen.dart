import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../widgets/animated_cityscape_background.dart';
import '../../widgets/app_drawer.dart';
import '../circle/trusted_circle_screen.dart';
import '../map/map_screen.dart';
import '../profile/profile_screen.dart';
import '../reports/reports_screen.dart';
import '../sos/sos_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _selectDestination(int index) => setState(() => selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    if (selectedIndex == 1) return MapScreen();
    if (selectedIndex == 2) return const SOSScreen();
    if (selectedIndex == 4) return ProfileScreen();

    return Scaffold(
      backgroundColor: AppTheme.background,
      drawer: AppDrawer(),
      body: Stack(
        children: [
          const Positioned.fill(child: AnimatedCityscapeBackground()),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: _buildHeader(),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 132),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight - 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildGreeting(),
                            const SizedBox(height: 18),
                            _buildLiveStatus(),
                            const SizedBox(height: 20),
                            _buildQuickActions(),
                            const SizedBox(height: 20),
                            _buildInsights(),
                            const SizedBox(height: 20),
                            _buildRecentIncidents(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(left: 16, right: 16, bottom: 12, child: _buildBottomNavigation()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Builder(
          builder: (context) => _IconButton(
            icon: Icons.menu_rounded,
            onTap: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        const SizedBox(width: 10),
        const _ShieldLogo(size: 38),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SafeSphere', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              SizedBox(height: 1),
              Text('Your Safety, Our Priority', style: TextStyle(color: AppTheme.textSecondary, fontSize: 9.5)),
            ],
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            _IconButton(
              icon: Icons.notifications_none_rounded,
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('You are all caught up.')),
              ),
            ),
            Positioned(
              top: 7,
              right: 7,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(color: AppTheme.sosRed, shape: BoxShape.circle),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        GestureDetector(onTap: () => _selectDestination(4), child: const _Avatar(label: 'A')),
      ],
    );
  }

  Widget _buildGreeting() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Good evening, Aditya', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
        SizedBox(height: 5),
        Text.rich(
          TextSpan(
            text: "You're ",
            children: [
              TextSpan(text: 'protected', style: TextStyle(color: AppTheme.safeGreen, fontWeight: FontWeight.w800)),
              TextSpan(text: ' and safe'),
            ],
          ),
          style: TextStyle(fontSize: 15, color: AppTheme.textPrimary),
        ),
      ],
    );
  }

  Widget _buildLiveStatus() {
    return Container(
      height: 188,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.circleTeal.withOpacity(0.75)),
        boxShadow: AppTheme.glow(AppTheme.circleTeal, blur: 22, spread: 0),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _LiveMapPainter())),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, AppTheme.background.withOpacity(0.72)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [Icon(Icons.circle, color: AppTheme.safeGreen, size: 8), SizedBox(width: 6), Text('LIVE SAFETY STATUS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.6))]),
                const SizedBox(height: 8),
                const Text('LOW RISK', style: TextStyle(color: AppTheme.safeGreen, fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                const Text('Your area is currently safe', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                const Spacer(),
                const Row(children: [Icon(Icons.warning_amber_rounded, color: AppTheme.textSecondary, size: 15), SizedBox(width: 6), Text('3 incidents nearby', style: TextStyle(fontSize: 11)), SizedBox(width: 16), Icon(Icons.people_alt_outlined, color: AppTheme.textSecondary, size: 15), SizedBox(width: 6), Text('12 in your circle', style: TextStyle(fontSize: 11))]),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _selectDestination(1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.16), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.primary.withOpacity(0.65))),
                    child: const Text('VIEW LIVE MAP  ->', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
          ),
          Positioned(right: 24, top: 38, child: CustomPaint(size: const Size(92, 92), painter: _RadarPainter())),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'QUICK ACTIONS', action: 'See all'),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 9,
          mainAxisSpacing: 9,
          childAspectRatio: 1.95,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _ActionCard(icon: Icons.location_on_rounded, title: 'Share Location', subtitle: 'Share your real-time location', color: AppTheme.primary, onTap: () => _showMessage('Location sharing is ready.')),
            _ActionCard(icon: Icons.route_rounded, title: 'Safe Route', subtitle: 'Find safer routes', color: AppTheme.routePurple, onTap: () => _selectDestination(1)),
            _ActionCard(icon: Icons.warning_amber_rounded, title: 'Report Incident', subtitle: 'Report suspicious activity', color: AppTheme.warning, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsScreen()))),
            _ActionCard(icon: Icons.people_alt_rounded, title: 'Trusted Circle', subtitle: 'Manage trusted contacts', color: AppTheme.circleTeal, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TrustedCircleScreen()))),
          ],
        ),
      ],
    );
  }

  Widget _buildInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'SAFETY INSIGHTS', action: 'See more'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
          decoration: BoxDecoration(color: AppTheme.surface.withOpacity(0.82), borderRadius: BorderRadius.circular(17), border: Border.all(color: AppTheme.circleTeal.withOpacity(0.35))),
          child: Row(
            children: [
              const Icon(Icons.trending_up_rounded, color: AppTheme.circleTeal, size: 28),
              const SizedBox(width: 11),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Your area is safer than yesterday', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)), SizedBox(height: 4), Text('18% fewer incidents', style: TextStyle(color: AppTheme.safeGreen, fontSize: 11, fontWeight: FontWeight.w700))])),
              SizedBox(width: 75, height: 36, child: CustomPaint(painter: _TrendPainter())),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentIncidents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'RECENT INCIDENTS', action: 'View all', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsScreen()))),
        const SizedBox(height: 10),
        const _IncidentCard(icon: Icons.visibility_rounded, iconColor: AppTheme.warning, title: 'Suspicious Activity', location: 'Tambaram Main Road', time: '2 hours ago', severity: 'MEDIUM', severityColor: AppTheme.warning),
        const SizedBox(height: 8),
        const _IncidentCard(icon: Icons.car_crash_rounded, iconColor: AppTheme.sosRed, title: 'Traffic Accident', location: 'GST Road', time: 'Yesterday', severity: 'HIGH', severityColor: AppTheme.sosRed),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return SizedBox(
      height: 76,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: 68,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(color: const Color(0xF2071220), borderRadius: BorderRadius.circular(23), border: Border.all(color: AppTheme.primary.withOpacity(0.3)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.45), blurRadius: 20, offset: const Offset(0, 7))]),
            child: Row(
              children: [
                _NavItem(icon: Icons.home_rounded, label: 'Home', selected: selectedIndex == 0, onTap: () => _selectDestination(0)),
                _NavItem(icon: Icons.map_rounded, label: 'Map', selected: selectedIndex == 1, onTap: () => _selectDestination(1)),
                const SizedBox(width: 66),
                _NavItem(icon: Icons.notifications_rounded, label: 'Alerts', selected: selectedIndex == 3, onTap: () => _showMessage('No new alerts.')),
                _NavItem(icon: Icons.person_rounded, label: 'Profile', selected: selectedIndex == 4, onTap: () => _selectDestination(4)),
              ],
            ),
          ),
          Positioned(
            top: -12,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) => Transform.scale(
                scale: 1 + (_pulseController.value * 0.04),
                child: GestureDetector(
                  onTap: () => _selectDestination(2),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(shape: BoxShape.circle, gradient: AppTheme.sosGradient, border: Border.all(color: Colors.white.withOpacity(0.3), width: 2), boxShadow: AppTheme.glow(AppTheme.sosRed, blur: 24, spread: 3)),
                    child: const Center(child: Text('SOS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14))),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(width: 42, height: 42, decoration: BoxDecoration(color: Colors.white.withOpacity(0.045), borderRadius: BorderRadius.circular(13), border: Border.all(color: Colors.white.withOpacity(0.12))), child: Icon(icon, color: AppTheme.textPrimary, size: 21)),
      );
}

class _ShieldLogo extends StatelessWidget {
  final double size;
  const _ShieldLogo({required this.size});
  @override
  Widget build(BuildContext context) => Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, gradient: AppTheme.shieldGradient, boxShadow: AppTheme.glow(AppTheme.primary, blur: 18, spread: 1)), child: Icon(Icons.shield_rounded, color: Colors.white, size: size * 0.54));
}

class _Avatar extends StatelessWidget {
  final String label;
  const _Avatar({required this.label});
  @override
  Widget build(BuildContext context) => Container(width: 42, height: 42, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [Color(0xFF6BE5F6), Color(0xFF193566)]), border: Border.all(color: AppTheme.primary.withOpacity(0.75), width: 1.5)), child: Center(child: Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800))));
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback? onTap;
  const _SectionHeader({required this.title, required this.action, this.onTap});
  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 0.5)), InkWell(onTap: onTap, child: Text(action, style: const TextStyle(color: AppTheme.primary, fontSize: 10, fontWeight: FontWeight.w700)))]);
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  const _ActionCard({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(color: AppTheme.surface.withOpacity(0.84), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.62)), boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 16)]),
          child: Row(children: [Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.16)), child: Icon(icon, color: color, size: 19)), const SizedBox(width: 8), Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800)), const SizedBox(height: 2), Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 8.5))])), Icon(Icons.chevron_right_rounded, color: color.withOpacity(0.85), size: 17)]),
        ),
      );
}

class _IncidentCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String location;
  final String time;
  final String severity;
  final Color severityColor;
  const _IncidentCard({required this.icon, required this.iconColor, required this.title, required this.location, required this.time, required this.severity, required this.severityColor});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(color: AppTheme.surface.withOpacity(0.85), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.primary.withOpacity(0.2))),
        child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: iconColor.withOpacity(0.14), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: iconColor, size: 21)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text('$location  .  $time', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 9.5))])), Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4), decoration: BoxDecoration(color: severityColor.withOpacity(0.14), borderRadius: BorderRadius.circular(7), border: Border.all(color: severityColor.withOpacity(0.45))), child: Text(severity, style: TextStyle(color: severityColor, fontSize: 8, fontWeight: FontWeight.w800))), const SizedBox(width: 4), const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary, size: 18)]),
      );
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) => Expanded(child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: Container(decoration: BoxDecoration(color: selected ? AppTheme.primary.withOpacity(0.16) : Colors.transparent, borderRadius: BorderRadius.circular(16)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: selected ? AppTheme.primary : AppTheme.textSecondary, size: 20), const SizedBox(height: 3), Text(label, style: TextStyle(color: selected ? AppTheme.textPrimary : AppTheme.textSecondary, fontSize: 9, fontWeight: selected ? FontWeight.w700 : FontWeight.w500))]))));
}

class _LiveMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()..color = AppTheme.primary.withOpacity(0.13)..strokeWidth = 1;
    for (double x = -size.height; x < size.width + size.height; x += 28) canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), grid);
    for (double y = 8; y < size.height; y += 24) canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    final route = Paint()..color = AppTheme.circleTeal.withOpacity(0.55)..style = PaintingStyle.stroke..strokeWidth = 1.2;
    final path = Path()..moveTo(size.width * 0.52, size.height)..lineTo(size.width * 0.58, size.height * 0.65)..lineTo(size.width * 0.47, size.height * 0.37)..lineTo(size.width * 0.67, 0);
    canvas.drawPath(path, route);
    for (final point in [Offset(size.width * .52, size.height * .65), Offset(size.width * .76, size.height * .3), Offset(size.width * .34, size.height * .2)]) {
      canvas.drawCircle(point, 3, Paint()..color = AppTheme.circleTeal..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5));
      canvas.drawCircle(point, 2, Paint()..color = AppTheme.circleTeal);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RadarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (final radius in [18.0, 34.0, 48.0]) canvas.drawCircle(center, radius, Paint()..color = AppTheme.circleTeal.withOpacity(0.3)..style = PaintingStyle.stroke..strokeWidth = 1);
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), Paint()..color = AppTheme.circleTeal.withOpacity(0.18));
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), Paint()..color = AppTheme.circleTeal.withOpacity(0.18));
    canvas.drawCircle(center, 5, Paint()..color = AppTheme.primary..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7));
    canvas.drawCircle(center, 3, Paint()..color = Colors.white);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TrendPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppTheme.safeGreen..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final path = Path()..moveTo(2, size.height - 4)..lineTo(15, size.height - 14)..lineTo(25, size.height - 9)..lineTo(39, size.height - 25)..lineTo(50, size.height - 18)..lineTo(64, 5)..lineTo(size.width - 2, 2);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
