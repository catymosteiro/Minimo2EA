class Location {
  double latitude;
  double longitude;
  Location({required this.latitude, required this.longitude});

  factory Location.fromJson(dynamic json) {
    return Location(
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }
  static Map<String, dynamic> toJson(Location values) {
    return {'latitude': values.latitude, 'longitude': values.longitude};
  }
}
