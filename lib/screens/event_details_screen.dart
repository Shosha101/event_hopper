import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:event_hopper/models/event_model.dart';
import 'package:event_hopper/themes/app_theme.dart';
import 'package:event_hopper/widgets/app_widgets.dart';
import 'package:event_hopper/widgets/events_map.dart';
import 'package:flutter/material.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventModel event;
  final EventsMapBuilder? mapBuilder;

  const EventDetailsScreen({super.key, required this.event, this.mapBuilder});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final topInset = MediaQuery.of(context).padding.top;
    final heroHeight = deviceHeight * 0.40;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: heroHeight,
              width: double.infinity,
              child: EventImage(imagePath: event.imagePath),
            ),
            // Keeps the round buttons readable on bright photos
            Container(
              height: topInset + 80,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black38, Colors.transparent],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: heroHeight - 28),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ContentText(
                      event.title,
                      style: const TextStyle(
                        fontSize: 24,
                        height: 1.3,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _InfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: context.tr('details_date_time'),
                      value: formatEventDateTime(context, event.dateTime),
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      label: context.tr('details_location'),
                      value: event.location,
                    ),
                    const SizedBox(height: 24),
                    _SectionTitle(context.tr('details_about')),
                    const SizedBox(height: 8),
                    Text(
                      event.about,
                      textDirection: Bidi.detectRtlDirectionality(event.about)
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.7,
                        color: AppColors.muted,
                      ),
                    ),
                    if (mapBuilder != null || EventsMap.isSupported) ...[
                      const SizedBox(height: 24),
                      _SectionTitle(context.tr('details_map')),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppTheme.radius),
                        child: SizedBox(
                          height: 160,
                          child: mapBuilder != null
                              ? mapBuilder!(context, [event], event, null)
                              : EventsMap(
                                  events: [event],
                                  selected: event,
                                  preview: true,
                                ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            PositionedDirectional(
              top: topInset + 12,
              start: 16,
              child: CircleIconButton(
                icon: Icons.arrow_back,
                tooltip: context.tr('back'),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            PositionedDirectional(
              top: topInset + 12,
              end: 16,
              child: FavoriteButton(event: event),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: FilledButton.icon(
              onPressed: () => openEventInGoogleMaps(context, event),
              icon: const Icon(Icons.directions_outlined),
              label: Text(context.tr('get_directions')),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.accentSoft,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.accent, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12.5, color: AppColors.muted),
              ),
              const SizedBox(height: 2),
              ContentText(
                value,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
