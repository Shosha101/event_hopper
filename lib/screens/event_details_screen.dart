import 'package:event_hopper/widgets/rounded_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class EventDetailsScreen extends StatelessWidget {
  final String imagePath;
  final String title;
  final String dateTime;
  final String location;
  final String description;
  final LatLng googleMapsLocation;

  const EventDetailsScreen({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.dateTime,
    required this.location,
    required this.description,
    required this.googleMapsLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _deviceHeight = MediaQuery.of(context).size.height;
    double _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: _deviceHeight * 0.40,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _deviceWidth * 0.04,
                vertical: _deviceHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color.fromRGBO(244, 63, 139, 1.0),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dateTime,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    location,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoundedButton(
                        text: 'Get direction',
                        color: Color.fromRGBO(244, 63, 139, 1.0),
                        onPressed: () async {
                          _openGoogleMaps(googleMapsLocation);
                        },
                      ),
                      SizedBox(width: _deviceWidth * 0.02),
                      RoundedButton(
                        text: 'Add to favorite',
                        color: Color.fromRGBO(244, 63, 139, 1.0),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openGoogleMaps(LatLng location) async {
    final url =
        'https://www.google.com/maps?q=${location.latitude},${location.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open Google Maps';
    }
  }
}
