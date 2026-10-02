import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:event_hopper/models/event_model.dart';
import 'package:event_hopper/providers/event_provider.dart';
import 'package:event_hopper/services/navigation_services.dart';
import 'package:event_hopper/themes/app_theme.dart';
import 'package:event_hopper/widgets/app_widgets.dart';
import 'package:event_hopper/widgets/events_map.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'event_details_screen.dart';

class EventMapScreen extends StatefulWidget {
  final EventsMapBuilder? mapBuilder;

  const EventMapScreen({super.key, this.mapBuilder});

  @override
  State<EventMapScreen> createState() => _EventMapScreenState();
}

class _EventMapScreenState extends State<EventMapScreen> {
  EventModel? _selectedEvent;

  void _selectEvent(EventModel event) {
    setState(() {
      _selectedEvent = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    final events = context.watch<EventProvider>().events;
    final selected = events.contains(_selectedEvent)
        ? _selectedEvent
        : (events.isEmpty ? null : events.first);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: widget.mapBuilder != null
                ? widget.mapBuilder!(context, events, selected, _selectEvent)
                : EventsMap(
                    events: events,
                    selected: selected,
                    onSelect: _selectEvent,
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _FloatingCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr('map_title'),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.text,
                                ),
                              ),
                              Text(
                                context.plural('events_count', events.length),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const LanguagePill(),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (selected != null) _SelectedEventCard(event: selected),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedEventCard extends StatelessWidget {
  final EventModel event;
  const _SelectedEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return _FloatingCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedBox(
                width: 84,
                height: 84,
                child: EventImage(imagePath: event.imagePath, borderRadius: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ContentText(
                      event.title,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 15.5,
                        height: 1.35,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    IconLine(
                      icon: Icons.calendar_today_outlined,
                      text: formatEventDateTime(context, event.dateTime),
                    ),
                    const SizedBox(height: 4),
                    IconLine(
                      icon: Icons.location_on_outlined,
                      text: formatEventPlace(context, event),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    GetIt.instance<NavigationService>().navigateToPage(
                      EventDetailsScreen(event: event),
                    );
                  },
                  child: Text(context.tr('view_details')),
                ),
              ),
              const SizedBox(width: 10),
              Tooltip(
                message: context.tr('get_directions'),
                child: OutlinedButton(
                  onPressed: () => openEventInGoogleMaps(context, event),
                  child: const Icon(Icons.directions_outlined),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// White rounded panel with a soft shadow, drawn over the map.
class _FloatingCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _FloatingCard({required this.child, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
