import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:event_hopper/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../models/event_model.dart';
import '../services/navigation_services.dart';
import '../themes/app_theme.dart';
import '../widgets/app_widgets.dart';
import '../widgets/event_card_widget.dart';
import '../widgets/horizontal_button_list.dart';
import '../widgets/search_textfield_widget.dart';
import 'event_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Label key of each category and the word it looks for in event titles.
  // The events have no category field, so a category is a title match.
  static const List<(String, String)> _categories = [
    ('category_all', ''),
    ('category_music', 'music'),
    ('category_technology', 'technology'),
    ('category_art', 'art'),
    ('category_sports', 'sports'),
    ('category_conferences', 'conference'),
    ('category_food_drink', 'drink'),
  ];

  final NavigationService navigationService =
      GetIt.instance<NavigationService>();

  List<EventModel> allEvents = [];
  List<EventModel> filteredEvents = [];
  bool isLoading = true;
  String searchQuery = '';
  int selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    _loadEvents(); // Automatically loads events, including mock data if the database is empty
  }

  Future<void> _loadEvents() async {
    try {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      // Coming back to this tab: show what is already loaded while it refreshes
      if (eventProvider.events.isNotEmpty) {
        allEvents = eventProvider.events;
        filteredEvents = eventProvider.events;
        isLoading = false;
      }
      await eventProvider.getEvent(); // Fetch events from provider
      if (!mounted) return;
      setState(() {
        allEvents = eventProvider.events;
        isLoading = false;
      });
      _updateFilteredEvents();
    } catch (e) {
      debugPrint("Error loading events: $e");
    }
  }

  void _updateFilteredEvents() {
    final category = _categories[selectedCategory].$2;
    setState(() {
      filteredEvents = allEvents.where((event) {
        final title = event.title.toLowerCase();
        return title.contains(searchQuery.toLowerCase()) &&
            title.contains(category);
      }).toList();
    });
  }

  void _filterEvents(int category) {
    selectedCategory = category;
    _updateFilteredEvents();
  }

  void _openEvent(EventModel event) {
    navigationService.navigateToPage(EventDetailsScreen(event: event));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/logo.png', height: 30),
                        const Spacer(),
                        const LanguagePill(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ScreenHeader(
                      title: context.tr('home_title'),
                      subtitle: context.tr('home_subtitle'),
                      showLanguagePill: false,
                    ),
                    const SizedBox(height: 16),
                    SearchTextFieldWidget(
                      onSearchChanged: (query) {
                        searchQuery = query;
                        _updateFilteredEvents();
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: HorizontalButtonList(
                buttonTexts: [
                  for (final category in _categories) context.tr(category.$1),
                ],
                selectedIndex: selectedCategory,
                buttonHeight: 44,
                buttonPadding: 8,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                onPressed: _filterEvents,
              ),
            ),
            if (isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (filteredEvents.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: StateMessage(
                    icon: Icons.search_off,
                    title: context.tr('no_events_title'),
                    body: context.tr('no_events_body'),
                  ),
                ),
              )
            else ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                        child: Text(
                          context.tr(_categories[selectedCategory].$1),
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                      Text(
                        context.plural('events_count', filteredEvents.length),
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: EventCardsSliver(
                  events: filteredEvents,
                  onTap: _openEvent,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
