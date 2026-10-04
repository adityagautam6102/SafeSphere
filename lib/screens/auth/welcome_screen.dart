import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../widgets/animated_cityscape_background.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedCityscapeBackground(),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(height: 24),
                  _buildHeroShield(),
                  SizedBox(height: 28),
                  _buildWordmark(context),
                  SizedBox(height: 20),
                  _buildTagline(),
                  SizedBox(height: 28),
                  _buildFeatureRow(),
                  SizedBox(height: 28),
                  _buildGetStartedButton(context),
                  SizedBox(height: 18),
                  _buildDivider(),
                  SizedBox(height: 18),
                  _buildLoginLink(context),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroShield() {
    return SizedBox(
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(top: 30, left: 4, child: _pin(AppTheme.primary, Icons.circle, small: true)),
          Positioned(top: 10, right: 10, child: _pin(AppTheme.safeGreen, Icons.shield, small: false)),
          Positioned(bottom: 20, right: 0, child: _pin(AppTheme.sosRed, Icons.warning_rounded, small: false)),

          // Main glowing shield
          Container(
            width: 150,
            height: 170,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: AppTheme.primary.withOpacity(0.5), blurRadius: 50, spreadRadius: 6),
                BoxShadow(color: AppTheme.routePurple.withOpacity(0.35), blurRadius: 60, spreadRadius: 2),
              ],
            ),
            child: CustomPaint(
              painter: _ShieldPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pin(Color color, IconData icon, {required bool small}) {
    final size = small ? 26.0 : 40.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.8), width: small ? 2 : 0),
        boxShadow: AppTheme.glow(color, blur: 16, spread: 2),
      ),
      child: small ? null : Icon(icon, color: Colors.white, size: 18),
    );
  }

  Widget _buildWordmark(BuildContext context) {
    return Column(
      children: [
        Text(
          'W E L C O M E   T O',
          style: TextStyle(fontSize: 12, letterSpacing: 3, color: AppTheme.textSecondary, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 6),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 42, fontWeight: FontWeight.w800, height: 1.0),
            children: [
              TextSpan(text: 'Safe', style: TextStyle(color: Colors.white)),
              TextSpan(
                text: 'Sphere',
                style: TextStyle(
                  foreground: Paint()
                    ..shader = LinearGradient(colors: [Color(0xFF6D8CFF), AppTheme.routePurple])
                        .createShader(Rect.fromLTWH(0, 0, 220, 50)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 18),
        Text(
          'Your Safety,',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white, height: 1.15),
        ),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [AppTheme.routePurple, AppTheme.safeGreen],
          ).createShader(bounds),
          child: Text(
            'Our Priority.',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white, height: 1.15),
          ),
        ),
      ],
    );
  }

  Widget _buildTagline() {
    return Column(
      children: [
        Text(
          'Stay protected. Stay connected.',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
        ),
        SizedBox(height: 8),
        Text(
          'Real-time safety awareness, emergency protection\nand trusted connections — wherever you go.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.5, color: AppTheme.textSecondary, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildFeatureRow() {
    final features = [
      {'icon': Icons.shield_outlined, 'title': 'Real-time\nProtection', 'desc': 'Live safety monitoring around you', 'color': AppTheme.circleTeal},
      {'icon': Icons.sos_rounded, 'title': 'Emergency\nResponse', 'desc': 'Instant SOS alerts to trusted contacts', 'color': AppTheme.sosRed},
      {'icon': Icons.alt_route_rounded, 'title': 'Safe\nNavigation', 'desc': 'Smart routes for a safer journey', 'color': AppTheme.routePurple},
      {'icon': Icons.groups_rounded, 'title': 'Trusted\nCircle', 'desc': 'Stay connected with your people', 'color': AppTheme.circleTeal},
    ];

    return Row(
      children: features.map((f) {
        final color = f['color'] as Color;
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 3),
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.07),
              border: Border.all(color: color.withOpacity(0.45)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(9),
                  decoration: BoxDecoration(color: color.withOpacity(0.18), shape: BoxShape.circle),
                  child: Icon(f['icon'] as IconData, color: color, size: 18),
                ),
                SizedBox(height: 8),
                Text(
                  f['title'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppTheme.textPrimary, height: 1.2),
                ),
                SizedBox(height: 4),
                Text(
                  f['desc'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 8.5, color: AppTheme.textSecondary, height: 1.2),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
      },
      child: Container(
        width: double.infinity,
        height: 58,
        padding: EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF4F46E5)]),
          borderRadius: BorderRadius.circular(30),
          boxShadow: AppTheme.glow(AppTheme.primary, blur: 26, spread: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 40),
            Expanded(
              child: Text(
                'GET STARTED',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1),
              ),
            ),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Icon(Icons.arrow_forward, color: Colors.white, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppTheme.surfaceLight)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('or', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        ),
        Expanded(child: Divider(color: AppTheme.surfaceLight)),
      ],
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'I already have an account',
            style: TextStyle(fontSize: 14, color: AppTheme.primary, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 4),
          Icon(Icons.chevron_right, color: AppTheme.primary, size: 18),
        ],
      ),
    );
  }
}

// Shield silhouette with gradient stroke + checkmark, matching the reference glow
class _ShieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(w / 2, 0);
    path.lineTo(w, h * 0.18);
    path.lineTo(w, h * 0.55);
    path.cubicTo(w, h * 0.8, w * 0.75, h * 0.95, w / 2, h);
    path.cubicTo(w * 0.25, h * 0.95, 0, h * 0.8, 0, h * 0.55);
    path.lineTo(0, h * 0.18);
    path.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1A1F35), Color(0xFF161B2E)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(path, fillPaint);

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF60A5FA), Color(0xFFA855F7)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(path, strokePaint);

    // Checkmark
    final checkPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = LinearGradient(colors: [Color(0xFF818CF8), Color(0xFFA855F7)])
          .createShader(Rect.fromLTWH(0, 0, w, h));

    final checkPath = Path()
      ..moveTo(w * 0.3, h * 0.48)
      ..lineTo(w * 0.45, h * 0.62)
      ..lineTo(w * 0.72, h * 0.32);
    canvas.drawPath(checkPath, checkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

