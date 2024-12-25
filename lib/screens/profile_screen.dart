import 'package:flutter/cupertino.dart';

import '../widgets/event_card_widget.dart';
import '../widgets/horizontal_button_list.dart';
import '../widgets/search_textfield_widget.dart';

class ProfileScreen extends StatelessWidget {
  late double _deviceHeight;
  late double _deviceWidth;
  final List<String> _buttonTexts = [
    'All Events',
    'Music',
    'Sports',
    'Art',
    'Technology'
  ];
  // Sample event data
  final List<Map<String, String>> _events = [
    {
      'imageUrl': 'https://via.placeholder.com/100',
      'title': 'Music Concert',
      'dateTime': 'Dec 25, 2024 | 7:00 PM',
      'location': 'City Hall, Downtown',
    },
    {
      'imageUrl': 'https://via.placeholder.com/100',
      'title': 'Art Exhibition',
      'dateTime': 'Jan 10, 2025 | 11:00 AM',
      'location': 'Art Gallery, Main Street',
    },
    {
      'imageUrl': 'https://via.placeholder.com/100',
      'title': 'Tech Conference',
      'dateTime': 'Feb 15, 2025 | 9:00 AM',
      'location': 'Tech Park, Silicon Valley',
    },
  ];
  ProfileScreen createState() {
    return ProfileScreen();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Center(

      child: Text('ProfileScreen'),
    );
  }

}