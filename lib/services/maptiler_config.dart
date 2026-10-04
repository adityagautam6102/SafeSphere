class MapTilerConfig {
  static const String apiKey = 'd6180a32-0499-4d82-8734-09e1ffd4d3d2';

  static String get darkTileUrl =>
      'https://api.maptiler.com/maps/streets-v2-dark/{z}/{x}/{y}.png?key=$apiKey';
}
