import 'package:event_hopper/providers/event_provider.dart';
import 'package:event_hopper/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:event_hopper/screens/splash_screen.dart';
import 'package:event_hopper/services/hive_service.dart';
import 'package:event_hopper/services/navigation_services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'Adapters/lating_adapter.dart';

void main()  {

  runApp(SplashPage(onInitializationComplete: () {
    runApp(MyApp());
  }));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final HiveService hiveService = GetIt.instance<HiveService>();
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
  }


  Future<void> _closeHive() async {
    try {
      await hiveService.clearAllEvents(); // Clear events when the app is closed
      await hiveService.closeHive();     // Close Hive safely
      logger.i("Hive cleared and closed successfully.");
    } catch (e) {
      logger.e("Error while closing Hive: $e");
    }
  }

  @override
  void dispose() {
    _closeHive();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => EventProvider(),
      child: MaterialApp(
        initialRoute: '/main',
        navigatorKey: NavigationService.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'EventHopper',
        theme: ThemeData.light(),
        routes: {
          '/main': (BuildContext context) => MainScreen(),
        },
      ),
    );
  }
}
