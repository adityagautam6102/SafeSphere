import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;

import '../../services/location_service.dart';
import '../../services/maptiler_config.dart';
import '../../theme.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController destinationController = TextEditingController();
  final MapController mapController = MapController();
  LatLng currentLatLng = const LatLng(12.9249, 80.1000);
  bool showRoutes = false;
  int selectedRouteIndex = 0;

  final List<Map<String, dynamic>> routes = [
    {
      'label': 'Safest Route',
      'duration': '18 min',
      'distance': '3.2 km',
      'safetyScore': 92,
      'description': 'Well-lit main roads, high foot traffic',
      'icon': Icons.shield_outlined,
    },
    {
      'label': 'Fastest Route',
      'duration': '12 min',
      'distance': '2.6 km',
      'safetyScore': 61,
      'description': 'Includes 2 poorly-lit side streets',
      'icon': Icons.bolt_outlined,
    },
  ];

  final List<Map<String, String>> nearbyIncidentMarkers = [
    {'type': 'Theft', 'location': 'Near GST Road junction', 'time': '2h ago'},
    {'type': 'Suspicious Activity', 'location': 'Tambaram Bus Stand', 'time': '5h ago'},
    {'type': 'Accident', 'location': 'Mudichur Road', 'time': '1d ago'},
  ];

  @override
  void dispose() {
    destinationController.dispose();
    super.dispose();
  }

  Color safetyColor(int score) {
    if (score >= 80) return Color(0xFF22C55E);
    if (score >= 60) return AppTheme.warning;
    return AppTheme.error;
  }

  void searchRoutes() {
    if (destinationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enter a destination first'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }
    setState(() {
      showRoutes = true;
      selectedRouteIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Map & Routes'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildMapPlaceholder(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  SizedBox(height: 20),
                  if (showRoutes) ...[
                    _buildRouteComparison(),
                    SizedBox(height: 20),
                  ],
                  Text(
                    'Recent Incidents on Map',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 12),
                  _buildIncidentMarkersList(),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: currentLatLng,
          initialZoom: 14,
          onMapReady: () async {
            final position = await LocationService.getCurrentLocation();
            if (position != null) {
              final latLng = LatLng(position.latitude, position.longitude);
              setState(() => currentLatLng = latLng);
              mapController.move(latLng, 14);
            }
          },
        ),
        children: [
          TileLayer(
            urlTemplate: MapTilerConfig.darkTileUrl,
            userAgentPackageName: 'com.yourcompany.safesphere',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: currentLatLng,
                width: 36,
                height: 36,
                child: const Icon(
                  Icons.my_location,
                  color: AppTheme.primary,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.surfaceLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(width: 12),
          Icon(Icons.search, color: AppTheme.textSecondary, size: 20),
          Expanded(
            child: TextField(
              controller: destinationController,
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Where are you headed?',
                hintStyle: TextStyle(color: AppTheme.textSecondary),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              ),
              onSubmitted: (_) => searchRoutes(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 6),
            child: ElevatedButton(
              onPressed: searchRoutes,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: Text('Go', style: TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteComparison() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Route Options',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 12),
        ...routes.asMap().entries.map((entry) {
          final index = entry.key;
          final route = entry.value;
          final isSelected = selectedRouteIndex == index;
          final color = safetyColor(route['safetyScore'] as int);

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedRouteIndex = index;
              });
            },
            child: Container(
              padding: EdgeInsets.all(14),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.surfaceLight,
                  width: isSelected ? 1.5 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(route['icon'] as IconData, color: AppTheme.primary, size: 22),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          route['label'] as String,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          border: Border.all(color: color.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${route['safetyScore']}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: AppTheme.textSecondary),
                      SizedBox(width: 4),
                      Text(
                        route['duration'] as String,
                        style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.straighten, size: 14, color: AppTheme.textSecondary),
                      SizedBox(width: 4),
                      Text(
                        route['distance'] as String,
                        style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    route['description'] as String,
                    style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        SizedBox(height: 6),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Starting navigation on ${routes[selectedRouteIndex]['label']}...')),
              );
            },
            icon: Icon(Icons.navigation, size: 18),
            label: Text(
              'Start Navigation',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIncidentMarkersList() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.surfaceLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: nearbyIncidentMarkers.map((incident) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, color: AppTheme.warning, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        incident['type'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '${incident['location']} • ${incident['time']}',
                        style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}