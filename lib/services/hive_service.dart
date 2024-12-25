import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';

import '../models/event_model.dart';

class HiveService {
  Box<EventModel>? _eventBox; // Change to nullable type
  final Logger logger = Logger();

  // This ensures the box is open before anything is done with it.
  Future<void> openBox() async {
    try {
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(EventModelAdapter());
        logger.i('Adapter registered');
      }

      if (_eventBox == null || !_eventBox!.isOpen) { // Check if the box is open
        _eventBox = await Hive.openBox<EventModel>('eventsBox');
        logger.i('Events box opened');
      }
    } catch (e) {
      logger.e('Error initializing Hive: $e');
      rethrow;
    }
  }

  // Fetch events from Hive
  Future<List<EventModel>> getEvents() async {
    if (_eventBox == null || !_eventBox!.isOpen) {
      await openBox(); // Ensure the box is open before fetching events
    }
    return _eventBox!.values.toList();
  }

  // Adding mock data
  Future<void> addMockData() async {
    final mockEvents = [
      EventModel(
        title: 'Art Exhibition: "Masterpieces of the Modern World"',
        imagePath: 'assets/images/art.jpg',
        dateTime: DateTime(2024, 12, 30, 10, 0),
        location: 'Modern Art Gallery, San Francisco, USA',
        about: 'Experience a curated collection of the finest contemporary art. This exhibition brings together revolutionary artists who are shaping the future of visual culture. Expect to explore interactive installations, thought-provoking sculptures, and paintings that challenge conventional ideas. Each piece tells a unique story, highlighting both abstract and realist movements.',
        city: 'San Francisco',
        country: 'USA',
        googleMapsLocation: LatLng(37.7749, -122.4194),
      ),
      EventModel(
        title: 'Tech Conference 2024: "Innovation in AI and Beyond"',
        imagePath: 'assets/images/conference.jpg',
        dateTime: DateTime(2024, 11, 5, 9, 0),
        location: 'Silicon Valley Convention Center, San Jose, USA',
        about: 'Join tech enthusiasts, entrepreneurs, and industry leaders as they discuss the latest developments in artificial intelligence, machine learning, and data science. This conference offers insightful keynote speakers from top companies, workshops, and panel discussions. Whether youre a beginner or an expert, this event promises deep dives into topics like quantum computing, autonomous vehicles, and AI ethics.',
        city: 'San Jose',
        country: 'USA',
        googleMapsLocation: LatLng(37.3382, -121.8863),
      ),
      EventModel(
        title: 'Drinks & Cocktail Festival 2024',
        imagePath: 'assets/images/drinks.jpg',
        dateTime: DateTime(2024, 9, 20, 17, 0),
        location: 'Grand Ballroom, Chicago, USA',
        about: 'A must-attend event for cocktail lovers, bartenders, and enthusiasts! Sample exclusive cocktails crafted by world-renowned mixologists. Enjoy workshops on the art of bartending, learn the secrets behind classic and new-age drinks, and discover trends in the spirits industry. The festival also features local craft breweries, wine tasting booths, and an array of non-alcoholic beverages for all to enjoy.',
        city: 'Chicago',
        country: 'USA',
        googleMapsLocation: LatLng(41.8781, -87.6298),
      ),
      EventModel(
        title: 'Music Festival 2024: "The Sound of Tomorrow"',
        imagePath: 'assets/images/music.jpg',
        dateTime: DateTime(2024, 8, 15, 14, 0),
        location: 'Central Park, New York, USA',
        about: 'A celebration of music from every corner of the globe! With performances ranging from electronic beats to rock, indie, hip-hop, and classical crossovers, the festival features both well-established bands and up-and-coming artists. Explore multiple stages, enjoy the vibrant atmosphere, and experience live music like never before. The festival will also host interactive art displays, dance performances, and culinary delights.',
        city: 'New York',
        country: 'USA',
        googleMapsLocation: LatLng(40.7851, -73.9683),
      ),
      EventModel(
        title: 'International Sports Championship 2024',
        imagePath: 'assets/images/sports.jpg',
        dateTime: DateTime(2024, 6, 18, 10, 0),
        location: 'Olympic Stadium, London, UK',
        about: 'Witness some of the world\'s top athletes compete in a series of thrilling events including track and field, swimming, gymnastics, and team sports. This championship is a prestigious global event, bringing together athletes from around the world to showcase their skills and break records. Enjoy a variety of sporting exhibitions, fan zones, and a chance to meet your favorite sports personalities.',
        city: 'London',
        country: 'UK',
        googleMapsLocation: LatLng(51.5074, -0.1278),
      ),
      EventModel(
        title: 'Technology Expo 2024: "The Future of Tech and Sustainability"',
        imagePath: 'assets/images/technology.jpg',
        dateTime: DateTime(2024, 10, 25, 11, 0),
        location: 'Las Vegas Convention Center, Las Vegas, USA',
        about: 'Explore the latest innovations in technology with a focus on sustainability. This expo brings together cutting-edge startups and established companies to showcase products and solutions that are making a difference in energy efficiency, renewable tech, green building, and AI-powered sustainability. Attendees can experience live demos, attend discussions about the future of tech in our daily lives, and engage with thought leaders in the industry.',
        city: 'Las Vegas',
        country: 'USA',
        googleMapsLocation: LatLng(36.1699, -115.1398),
      ),
    ];

    for (var event in mockEvents) {
      await _eventBox?.add(event);
    }

    logger.i('Mock events added');
  }

  // Clear all events from Hive
  Future<void> clearAllEvents() async {
    if (_eventBox != null && _eventBox!.isOpen) {
      await _eventBox!.clear();
      logger.i("All events cleared.");
    }
  }

  // Close Hive Box
  Future<void> closeHive() async {
    if (_eventBox != null && _eventBox!.isOpen) {
      await _eventBox!.close();
      logger.i("Hive closed.");
    }
  }
}
