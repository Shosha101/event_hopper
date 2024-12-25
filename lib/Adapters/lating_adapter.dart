import 'package:hive/hive.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Custom adapter for LatLng
class LatLngAdapter extends TypeAdapter<LatLng> {
  @override
  final typeId = 1; // Use a unique typeId for LatLng

  @override
  LatLng read(BinaryReader reader) {
    final latitude = reader.readDouble();
    final longitude = reader.readDouble();
    return LatLng(latitude, longitude);
  }

  @override
  void write(BinaryWriter writer, LatLng obj) {
    writer.writeDouble(obj.latitude);
    writer.writeDouble(obj.longitude);
  }
}
