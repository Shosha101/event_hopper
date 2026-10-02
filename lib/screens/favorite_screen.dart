import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:event_hopper/providers/event_provider.dart';
import 'package:event_hopper/widgets/app_widgets.dart';
import 'package:event_hopper/widgets/event_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../services/navigation_services.dart';
import 'event_details_screen.dart';

class FavoriteScreen extends StatelessWidget {
  // Called from the empty state to send the user back to the events list.
  final VoidCallback? onBrowseEvents;

  const FavoriteScreen({super.key, this.onBrowseEvents});

  @override
  Widget build(BuildContext context) {
    final events = context.watch<EventProvider>().favoriteEvents;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              sliver: SliverToBoxAdapter(
                child: ScreenHeader(
                  title: context.tr('favorites_title'),
                  subtitle: events.isEmpty
                      ? null
                      : context.plural('events_count', events.length),
                ),
              ),
            ),
            if (events.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: StateMessage(
                    icon: Icons.favorite_border,
                    title: context.tr('favorites_empty_title'),
                    body: context.tr('favorites_empty_body'),
                    actionLabel: context.tr('browse_events'),
                    onAction: onBrowseEvents,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: EventCardsSliver(
                  events: events,
                  onTap: (event) {
                    GetIt.instance<NavigationService>().navigateToPage(
                      EventDetailsScreen(event: event),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
