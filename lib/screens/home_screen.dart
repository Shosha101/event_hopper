import 'package:event_hopper/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/event_model.dart';
import '../services/navigation_services.dart';
import '../widgets/event_card_widget.dart';
import '../widgets/horizontal_button_list.dart';
import '../widgets/search_textfield_widget.dart';
import 'event_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NavigationService navigationService = GetIt.instance<NavigationService>();

  List<EventModel> allEvents = [];
  List<EventModel> filteredEvents = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadEvents(); // Automatically loads events, including mock data if the database is empty
  }

  Future<void> _loadEvents() async {
    try {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      await eventProvider.getEvent(); // Fetch events from provider
      setState(() {
        allEvents = eventProvider.events;
        filteredEvents = eventProvider.events;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading events: $e");
    }
  }

  void _updateFilteredEvents() {
    setState(() {
      filteredEvents = allEvents.where((event) {
        final matchesSearch = event.title
            ?.toLowerCase()
            .contains(searchQuery.toLowerCase()) ??
            false;
        return matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double _deviceWidth = MediaQuery.of(context).size.width;
    bool isVertical = MediaQuery.of(context).orientation == Orientation.portrait;

    int crossAxisCount = _deviceWidth > 1200 ? 3 : (_deviceWidth > 800 ? 2 : 1);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 50, bottom: 16.0),
            child: SearchTextFieldWidget(
              onSearchChanged: (query) {
                searchQuery = query;
                _updateFilteredEvents();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: isVertical ? _deviceWidth * 0.01 : _deviceWidth * 0.04,
              bottom: 16.0,
            ),
            child: HorizontalButtonList(
              buttonTexts: const [
                'All events',
                'Music',
                'Technology',
                'Art',
                'Sports',
                'Conferences',
                'Food & Drink'
              ],
              buttonHeight: 50,
              buttonPadding: 5,
              buttonColor: const Color.fromRGBO(244, 63, 139, 1.0),
              onPressed: (category) {
                _filterEvents(category);
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredEvents.isEmpty
                ? Center(child: Text("No events found."))
                : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              padding: const EdgeInsets.all(16.0),
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                final formattedDateTime = DateFormat(
                    'MMMM dd, yyyy h:mm a')
                    .format(event.dateTime);
                return GestureDetector(
                  onTap: () {
                    navigationService.navigateToPage(
                      EventDetailsScreen(
                        imagePath: event.imagePath ??
                            'assets/images/default.jpg',
                        title: event.title ?? 'Unknown Event',
                        dateTime: formattedDateTime,
                        location: event.location ?? 'Unknown Location',
                        description: event.about ??
                            'No description available',
                        googleMapsLocation:
                        event.googleMapsLocation,
                      ),
                    );
                  },
                  child: EventCardWidget(
                    imageLoc: event.imagePath ??
                        'assets/images/default.jpg',
                    title: event.title ?? 'Unknown Event',
                    dateTime: formattedDateTime,
                    location: event.location ?? 'Unknown Location',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _filterEvents(String category) {
    setState(() {
      if (category == 'All events') {
        filteredEvents = allEvents;
      } else {
        filteredEvents = allEvents
            .where((event) =>
        event.title?.toLowerCase().contains(category.toLowerCase()) ??
            false)
            .toList();
      }
    });
  }
}
