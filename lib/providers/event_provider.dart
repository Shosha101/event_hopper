import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

import '../models/event_model.dart';
import '../services/hive_service.dart';

class EventProvider extends ChangeNotifier {
  List<EventModel> _events = [];
  final HiveService _hiveService = HiveService();
  final Logger logger = Logger();

  List<EventModel> get events => _events;

  // Load events from Hive and add mock data if necessary
  Future<void> getEvent() async {
    try {
      await _hiveService.openBox();  // Ensure Hive box is opened before accessing data

      _events = await _hiveService.getEvents();

      // Check if events are empty, add mock data if needed
      if (_events.isEmpty) {
        await _hiveService.addMockData();
        _events = await _hiveService.getEvents(); // Reload events after adding mock data
      }

      notifyListeners(); // Notify listeners that events are updated
    } catch (e) {
      logger.e('Error loading events: $e');
    }
  }
}
