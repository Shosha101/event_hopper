import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';

part 'event_model.g.dart'; // Required for the generated file

@HiveType(typeId: 0) // Assign a unique typeId for this model
class EventModel {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String imagePath;

  @HiveField(2)
  final DateTime dateTime;

  @HiveField(3)
  final String location;

  @HiveField(4)
  final String about;

  @HiveField(5)
  final String city;

  @HiveField(6)
  final String country;

  @HiveField(7)
  final LatLng googleMapsLocation;

  EventModel({
    required this.title,
    required this.imagePath,
    required this.dateTime,
    required this.location,
    required this.about,
    required this.city,
    required this.country,
    required this.googleMapsLocation,
  });
}
