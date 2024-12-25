import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EventMapScreen extends StatefulWidget {
  final LatLng eventLocation;
  final Position currentLocation;

  EventMapScreen({required this.eventLocation, required this.currentLocation});

  @override
  _EventMapScreenState createState() => _EventMapScreenState();
}

class _EventMapScreenState extends State<EventMapScreen> {
  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Location'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.currentLocation != null
              ? LatLng(widget.currentLocation.latitude, widget.currentLocation.longitude)
              : widget.eventLocation,
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId('current_location'),
            position: LatLng(widget.currentLocation.latitude, widget.currentLocation.longitude),
          ),
          Marker(
            markerId: MarkerId('event_location'),
            position: widget.eventLocation,
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openGoogleMapsForDirections();
        },
        child: Icon(Icons.directions),
      ),
    );
  }

  void _openGoogleMapsForDirections() {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=${widget.currentLocation.latitude},${widget.currentLocation.longitude}&destination=${widget.eventLocation.latitude},${widget.eventLocation.longitude}&travelmode=driving',
    );
    launchUrl(uri);
  }

  Future<void> launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
