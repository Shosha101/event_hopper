import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void removeAndNavigateToRoute(String route) {
    navigatorKey.currentState?.popAndPushNamed(route);
  }

  void navigateToRoute(String route) {
    navigatorKey.currentState?.pushNamed(route);
  }

  void navigateToPage(Widget page) {
    navigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  }

  void goBack() {
    navigatorKey.currentState?.pop();
  }
}
