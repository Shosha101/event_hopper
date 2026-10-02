import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:event_hopper/themes/app_theme.dart';
import 'package:event_hopper/widgets/events_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'event_map_screen.dart';
import 'favorite_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  final EventsMapBuilder? mapBuilder;

  const MainScreen({super.key, this.mapBuilder});

  @override
  State<StatefulWidget> createState() {
    return _MainScreen();
  }
}

class _MainScreen extends State<MainScreen> {
  int _selectedIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;

    final List<Widget> pages = [
      const HomeScreen(),
      EventMapScreen(mapBuilder: widget.mapBuilder),
      FavoriteScreen(onBrowseEvents: () => _selectPage(0)),
      const ProfileScreen(),
    ];

    final destinations = [
      (Icons.home_outlined, Icons.home, context.tr('nav_home')),
      (Icons.map_outlined, Icons.map, context.tr('nav_map')),
      (Icons.favorite_border, Icons.favorite, context.tr('nav_favorites')),
      (Icons.person_outline, Icons.person, context.tr('nav_profile')),
    ];

    return Scaffold(
      body: Row(
        children: [
          if (!isMobile)
            DecoratedBox(
              decoration: const BoxDecoration(
                border: BorderDirectional(
                  end: BorderSide(color: AppColors.border),
                ),
              ),
              child: NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _selectPage,
                groupAlignment: 0,
                labelType: NavigationRailLabelType.all,
                destinations: [
                  for (final (icon, selectedIcon, label) in destinations)
                    NavigationRailDestination(
                      icon: Icon(icon),
                      selectedIcon: Icon(selectedIcon),
                      label: Text(label),
                    ),
                ],
              ),
            ),
          Expanded(
            child: pages[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: isMobile
          ? DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: NavigationBar(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _selectPage,
                destinations: [
                  for (final (icon, selectedIcon, label) in destinations)
                    NavigationDestination(
                      icon: Icon(icon),
                      selectedIcon: Icon(selectedIcon),
                      label: label,
                    ),
                ],
              ),
            )
          : null,
    );
  }
}
