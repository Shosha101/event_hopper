import 'package:event_hopper/models/event_model.dart';
import 'package:event_hopper/themes/app_theme.dart';
import 'package:event_hopper/widgets/app_widgets.dart';
import 'package:flutter/material.dart';

class EventCardWidget extends StatelessWidget {
  static const double imageAspectRatio = 16 / 10;
  static const double _padding = 8;

  final EventModel event;
  final VoidCallback? onTap;

  const EventCardWidget({super.key, required this.event, this.onTap});

  // Card height for a given width, used where the grid needs a fixed extent.
  static double heightFor(double width, TextScaler textScaler) {
    final imageHeight = (width - _padding * 2) / imageAspectRatio;
    return _padding * 2 + imageHeight + textScaler.scale(126);
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(_padding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: imageAspectRatio,
                      child: EventImage(
                        imagePath: event.imagePath,
                        borderRadius: AppTheme.radius,
                      ),
                    ),
                    PositionedDirectional(
                      top: 10,
                      end: 10,
                      child: FavoriteButton(event: event),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ContentText(
                        event.title,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 17,
                          height: 1.35,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 8),
                      IconLine(
                        icon: Icons.calendar_today_outlined,
                        text: formatEventDateTime(context, event.dateTime),
                      ),
                      const SizedBox(height: 6),
                      IconLine(
                        icon: Icons.location_on_outlined,
                        text: formatEventPlace(context, event),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Sliver of event cards: one column on phones, two or three on wider screens.
class EventCardsSliver extends StatelessWidget {
  final List<EventModel> events;
  final ValueChanged<EventModel> onTap;

  const EventCardsSliver(
      {super.key, required this.events, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = deviceWidth > 1200 ? 3 : (deviceWidth > 800 ? 2 : 1);
    const spacing = 16.0;

    Widget card(BuildContext context, int index) => EventCardWidget(
          event: events[index],
          onTap: () => onTap(events[index]),
        );

    if (crossAxisCount == 1) {
      return SliverList.separated(
        itemCount: events.length,
        itemBuilder: card,
        separatorBuilder: (context, index) => const SizedBox(height: spacing),
      );
    }

    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final cardWidth =
            (constraints.crossAxisExtent - spacing * (crossAxisCount - 1)) /
                crossAxisCount;
        return SliverGrid.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            mainAxisExtent: EventCardWidget.heightFor(
              cardWidth,
              MediaQuery.textScalerOf(context),
            ),
          ),
          itemCount: events.length,
          itemBuilder: card,
        );
      },
    );
  }
}
