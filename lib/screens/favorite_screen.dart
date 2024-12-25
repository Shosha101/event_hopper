import 'package:event_hopper/widgets/event_card_widget.dart';
import 'package:flutter/material.dart';

import '../services/navigation_services.dart';

class FavoriteScreen extends StatelessWidget {
  late double _deviceHeight;
  late double _deviceWidth;

  final List<Map<String, String>> _events = [
    {
      'imageLoc': 'assets/images/music.jpg',
      'title': 'Music Concert',
      'dateTime': 'Dec 25, 2024 | 7:00 PM',
      'location': 'City Hall, Downtown',
    },
    {
      'imageLoc': 'assets/images/music.jpg',
      'title': 'Art Exhibition',
      'dateTime': 'Jan 10, 2025 | 11:00 AM',
      'location': 'Art Gallery, Main Street',
    },
    {
      'imageLoc': 'assets/images/music.jpg',
      'title': 'Tech Conference',
      'dateTime': 'Feb 15, 2025 | 9:00 AM',
      'location': 'Tech Park, Silicon Valley',
    },
  ];

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    // Determine the number of columns based on screen width
    int crossAxisCount = 1; // Default for narrow screens
    if (_deviceWidth > 1200) {
      crossAxisCount = 3; // Desktop or large tablets
    } else if (_deviceWidth > 800) {
      crossAxisCount = 2; // Medium tablets or small desktop screens
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _deviceWidth * 0.04,
                vertical: _deviceHeight * 0.02,
              ),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.8, // Adjust the aspect ratio for the cards
                ),
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  final event = _events[index];
                  return InkWell(
                    onTap: () {
                        NavigationService().navigateToRoute('/detail');

                    },
                    child: EventCardWidget(
                      imageLoc: event['imageLoc']!,
                      title: event['title']!,
                      dateTime: event['dateTime']!,
                      location: event['location']!,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
