import 'package:flutter/material.dart';
import 'dart:async';
import '../../theme.dart';

class SOSScreen extends StatefulWidget {
  const SOSScreen({super.key});

  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen>
    with SingleTickerProviderStateMixin {
  bool sosActive = false;
  bool countdownActive = false;
  int countdown = 10;

  Timer? countdownTimer;
  late AnimationController _pulseController;

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
    countdownTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void startCountdown() {
    countdownTimer?.cancel();

    setState(() {
      countdownActive = true;
      countdown = 10;
    });

    countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        setState(() {
          countdown--;
        });

        if (countdown <= 0) {
          timer.cancel();
          triggerSOS();
        }
      },
    );
  }

  void triggerSOS() {
    if (!mounted) return;

    setState(() {
      sosActive = true;
      countdownActive = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'SOS Activated! Emergency services notified.',
        ),
        backgroundColor: AppTheme.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void cancelCountdown() {
    countdownTimer?.cancel();

    setState(() {
      countdownActive = false;
      sosActive = false;
      countdown = 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text('Emergency SOS'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emergency Status
            if (sosActive)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppTheme.error.withOpacity(0.1),
                  border: Border.all(
                    color: AppTheme.error.withOpacity(0.5),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.warning,
                          color: AppTheme.error,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'SOS ACTIVE',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.error,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Emergency services have been notified. Help is on the way.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

            // Countdown Display
            if (countdownActive)
              Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppTheme.error.withOpacity(0.15),
                  border: Border.all(
                    color: AppTheme.error.withOpacity(0.4),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      '$countdown',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.error,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Release to cancel. Tap SOS to confirm.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: cancelCountdown,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.surfaceLight,
                        ),
                        child: const Text('Cancel Countdown'),
                      ),
                    ),
                  ],
                ),
              ),

            // SOS Button
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: sosActive ? null : startCountdown,
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.95,
                        end: 1.05,
                      ).animate(
                        CurvedAnimation(
                          parent: _pulseController,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: sosActive
                              ? AppTheme.surfaceLight
                              : AppTheme.error,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.error.withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning,
                              size: 56,
                              color: sosActive
                                  ? AppTheme.textSecondary
                                  : Colors.white,
                            ),

                            const SizedBox(height: 8),

                            Text(
                              sosActive
                                  ? '✓ SOS SENT'
                                  : 'PRESS SOS',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: sosActive
                                    ? AppTheme.textSecondary
                                    : Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (!sosActive && !countdownActive)
                    const Text(
                      'Tap to activate emergency SOS',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Location Sharing
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                border: Border.all(
                  color: AppTheme.surfaceLight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppTheme.primary,
                    size: 24,
                  ),

                  const SizedBox(width: 16),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location Sharing',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          'Active with emergency services',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppTheme.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Emergency Services
            Text(
              'Emergency Services',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                _buildEmergencyService(
                  emoji: '🚔',
                  name: 'Police',
                  number: '100',
                ),

                const SizedBox(width: 12),

                _buildEmergencyService(
                  emoji: '🚑',
                  name: 'Ambulance',
                  number: '102',
                ),

                const SizedBox(width: 12),

                _buildEmergencyService(
                  emoji: '🚒',
                  name: 'Fire',
                  number: '101',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Trusted Contacts
            Text(
              'Trusted Contacts',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 12),

            _buildTrustedContactsList(),

            const SizedBox(height: 24),

            // How It Works
            _buildHowItWorks(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyService({
    required String emoji,
    required String name,
    required String number,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Calling $name...'),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            border: Border.all(
              color: AppTheme.surfaceLight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 32),
              ),

              const SizedBox(height: 8),

              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                number,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrustedContactsList() {
    final List<Map<String, dynamic>> contacts = [
      {
        'name': 'Mom',
        'phone': '+91 98765 43210',
        'relation': 'Mother',
        'notified': true,
      },
      {
        'name': 'Best Friend',
        'phone': '+91 87654 32109',
        'relation': 'Friend',
        'notified': true,
      },
      {
        'name': 'Roommate',
        'phone': '+91 76543 21098',
        'relation': 'Roommate',
        'notified': false,
      },
    ];

    return Column(
      children: contacts.map((contact) {
        final String name = contact['name'] as String;
        final String relation = contact['relation'] as String;
        final bool notified = contact['notified'] as bool;

        return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            border: Border.all(
              color: AppTheme.surfaceLight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.primary.withOpacity(0.2),
                child: Text(
                  name[0].toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),

                    Text(
                      relation,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              if (notified)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withOpacity(0.2),
                    border: Border.all(
                      color: AppTheme.success.withOpacity(0.5),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Notified',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.success,
                    ),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHowItWorks() {
    final List<Map<String, String>> steps = [
      {
        'number': '1',
        'title': 'Press SOS Button',
        'desc': '10-second countdown begins',
      },
      {
        'number': '2',
        'title': 'Location Shared',
        'desc': 'Your location is instantly shared',
      },
      {
        'number': '3',
        'title': 'Authorities Notified',
        'desc': 'Police and emergency services alerted',
      },
      {
        'number': '4',
        'title': 'Contacts Alerted',
        'desc': 'Your trusted contacts receive alerts',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How SOS Works',
          style: Theme.of(context).textTheme.titleMedium,
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            border: Border.all(
              color: AppTheme.surfaceLight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: steps.asMap().entries.map((entry) {
              final int index = entry.key;
              final Map<String, String> step = entry.value;
              final bool isLast = index == steps.length - 1;

              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.primary.withOpacity(0.5),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            step['number']!,
                            style: const TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              step['title']!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 2),

                            Text(
                              step['desc']!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  if (!isLast) ...[
                    const SizedBox(height: 12),

                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Divider(
                        color: AppTheme.surfaceLight,
                        height: 1,
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}