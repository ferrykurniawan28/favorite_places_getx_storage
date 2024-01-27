import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory PlaceLocation.fromJson(Map<String, dynamic> json) {
    return PlaceLocation(
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
    );
  }
}

class Places {
  final String id;
  final String title;
  final File image;
  final PlaceLocation location;
  final DateTime dateTime = DateTime.now();

  Places({
    required this.title,
    required this.image,
    required this.location,
  }) : id = uuid.v4();

  factory Places.fromJson(Map<String, dynamic> json) {
    return Places(
      title: json['title'],
      image: File(json['image']),
      location: PlaceLocation.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image': image.path, // Assuming you want to store the file path
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
        'address': location.address,
      },
    };
  }
}
