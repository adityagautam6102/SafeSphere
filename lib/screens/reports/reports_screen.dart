import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../services/location_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String? selectedType;
  String selectedSeverity = 'Medium';

  final TextEditingController descriptionController =
      TextEditingController();

  bool locationLoading = true;

  double? latitude;
  double? longitude;

  String locationLabel = 'Fetching location...';

  final List<Map<String, dynamic>> incidentTypes = [
    {
      'label': 'Theft',
      'icon': Icons.wallet_outlined,
    },
    {
      'label': 'Harassment',
      'icon': Icons.report_gmailerrorred_outlined,
    },
    {
      'label': 'Suspicious Activity',
      'icon': Icons.visibility_outlined,
    },
    {
      'label': 'Accident',
      'icon': Icons.car_crash_outlined,
    },
    {
      'label': 'Assault',
      'icon': Icons.pan_tool_outlined,
    },
    {
      'label': 'Poor Lighting',
      'icon': Icons.lightbulb_outline,
    },
    {
      'label': 'Vandalism',
      'icon': Icons.broken_image_outlined,
    },
    {
      'label': 'Other',
      'icon': Icons.more_horiz,
    },
  ];

  final List<String> severities = [
    'Low',
    'Medium',
    'High',
  ];

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    if (!mounted) return;

    setState(() {
      locationLoading = true;
      locationLabel = 'Fetching location...';
    });

    try {
      final position = await LocationService.getCurrentLocation();

      if (!mounted) return;

      setState(() {
        locationLoading = false;

        if (position != null) {
          latitude = position.latitude;
          longitude = position.longitude;

          locationLabel =
              '${position.latitude.toStringAsFixed(4)}, '
              '${position.longitude.toStringAsFixed(4)}';
        } else {
          latitude = null;
          longitude = null;
          locationLabel = 'Location unavailable — tap to retry';
        }
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        locationLoading = false;
        latitude = null;
        longitude = null;
        locationLabel = 'Location unavailable — tap to retry';
      });
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (selectedType == null) {
      _showError('Please select an incident type');
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      _showError('Please add a description');
      return;
    }

    if (latitude == null || longitude == null) {
      _showError('Location not available yet — please wait');
      return;
    }

    // Backend integration will be added later.
    // This is currently a frontend/test submission.

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Report submitted. Thank you for keeping the community safe.',
        ),
        backgroundColor: AppTheme.success,
      ),
    );

    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text('Report Incident'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What happened?',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 12),

            _buildTypeGrid(),

            const SizedBox(height: 24),

            Text(
              'Severity',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 12),

            _buildSeveritySelector(),

            const SizedBox(height: 24),

            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 12),

            _buildDescriptionField(),

            const SizedBox(height: 24),

            Text(
              'Location',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 12),

            _buildLocationCard(),

            const SizedBox(height: 24),

            Text(
              'Photo (optional)',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 12),

            _buildPhotoAttach(),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton(
                onPressed: _submitReport,

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  'Submit Report',

                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Your report helps keep the community informed and safe. '
              'Reports can be submitted anonymously in Settings.',

              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),

              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeGrid() {
    return GridView.count(
      crossAxisCount: 2,

      shrinkWrap: true,

      physics: const NeverScrollableScrollPhysics(),

      mainAxisSpacing: 12,
      crossAxisSpacing: 12,

      childAspectRatio: 2.6,

      children: incidentTypes.map((type) {
        final bool isSelected =
            selectedType == type['label'];

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedType = type['label'] as String;
            });
          },

          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),

            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primary.withOpacity(0.15)
                  : AppTheme.surface,

              border: Border.all(
                color: isSelected
                    ? AppTheme.primary
                    : AppTheme.surfaceLight,

                width: isSelected ? 1.5 : 1,
              ),

              borderRadius: BorderRadius.circular(12),
            ),

            child: Row(
              children: [
                Icon(
                  type['icon'] as IconData,

                  size: 20,

                  color: isSelected
                      ? AppTheme.primary
                      : AppTheme.textSecondary,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    type['label'] as String,

                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 13,

                      fontWeight: FontWeight.w600,

                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSeveritySelector() {
    final Map<String, Color> colors = {
      'Low': AppTheme.success,
      'Medium': AppTheme.warning,
      'High': AppTheme.error,
    };

    return Row(
      children: severities.map((severity) {
        final bool isSelected =
            selectedSeverity == severity;

        final Color color = colors[severity]!;

        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedSeverity = severity;
              });
            },

            child: Container(
              margin: EdgeInsets.only(
                right: severity != severities.last ? 8 : 0,
              ),

              padding: const EdgeInsets.symmetric(
                vertical: 12,
              ),

              decoration: BoxDecoration(
                color: isSelected
                    ? color.withOpacity(0.2)
                    : AppTheme.surface,

                border: Border.all(
                  color: isSelected
                      ? color
                      : AppTheme.surfaceLight,
                ),

                borderRadius: BorderRadius.circular(10),
              ),

              child: Text(
                severity,

                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 13,

                  fontWeight: FontWeight.w600,

                  color: isSelected
                      ? color
                      : AppTheme.textSecondary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,

        border: Border.all(
          color: AppTheme.surfaceLight,
        ),

        borderRadius: BorderRadius.circular(12),
      ),

      child: TextField(
        controller: descriptionController,

        maxLines: 4,

        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 14,
        ),

        decoration: const InputDecoration(
          hintText:
              'Describe what you saw or experienced...',

          hintStyle: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
          ),

          border: InputBorder.none,

          contentPadding: EdgeInsets.all(14),
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return GestureDetector(
      onTap: locationLoading ? null : _loadLocation,

      child: Container(
        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: AppTheme.surface,

          border: Border.all(
            color: AppTheme.surfaceLight,
          ),

          borderRadius: BorderRadius.circular(12),
        ),

        child: Row(
          children: [
            if (locationLoading)
              const SizedBox(
                width: 20,
                height: 20,

                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.primary,
                ),
              )
            else
              const Icon(
                Icons.location_on,
                color: AppTheme.primary,
                size: 22,
              ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Current Location',

                    style: TextStyle(
                      fontSize: 13,

                      fontWeight: FontWeight.w600,

                      color: AppTheme.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    locationLabel,

                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            if (!locationLoading && latitude != null)
              const Icon(
                Icons.refresh_rounded,
                color: AppTheme.textSecondary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoAttach() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Photo attach coming soon',
            ),
          ),
        );
      },

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: AppTheme.surface,

          border: Border.all(
            color: AppTheme.surfaceLight,
          ),

          borderRadius: BorderRadius.circular(12),
        ),

        child: const Column(
          children: [
            Icon(
              Icons.add_a_photo_outlined,
              color: AppTheme.textSecondary,
              size: 28,
            ),

            SizedBox(height: 8),

            Text(
              'Tap to add a photo',

              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}