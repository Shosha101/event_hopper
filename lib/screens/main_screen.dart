import 'dart:io';

import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainScreen();
  }
}

int _selectedIndex = 0;
final List<Widget> _pages = [
  HomeScreen(),
  // FavoriteScreen(),
  ProfileScreen(),
  ProfileScreen(),
];

class _MainScreen extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    bool isMobile = Platform.isAndroid || Platform.isIOS;

    return Scaffold(
      body: Row(
        children: [
          if (!isMobile)
            Center(
              child: NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                selectedIconTheme: const IconThemeData(
                  color: Color.fromRGBO(244, 63, 139, 1.0),
                ),
                unselectedIconTheme: const IconThemeData(
                  color: Colors.grey,
                ),
                backgroundColor: Colors.white,
                labelType: NavigationRailLabelType.all,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorite'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person),
                    label: Text('Profile'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (value) {
                setState(() {
                  _selectedIndex = value;
                });
              },
              selectedItemColor: const Color.fromRGBO(244, 63, 139, 1.0),
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.white,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favorite',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            )
          : null,
    );
  }
}
