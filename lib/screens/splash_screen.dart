import 'package:event_hopper/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';

import '../Adapters/lating_adapter.dart';
import '../services/hive_service.dart';
import '../services/navigation_services.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onInitializationComplete;
  const SplashPage({required this.onInitializationComplete, Key? key})
      : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}
class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
          height: 250,
          width: 250,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/logo.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  late HiveService getService=GetIt.instance.get<HiveService>();
  // Initialize services like Hive
  Future<void> _initializeApp() async {
    final Logger logger = Logger();

    WidgetsFlutterBinding.ensureInitialized();

    try {
      Hive.initFlutter(); // Initialize Hive first
      Hive.registerAdapter(LatLngAdapter());

      _registerServices(); // Register other services

      await getService.openBox(); // Wait for Hive to initialize

      logger.i("Services registered successfully and Hive initialized.");
    } catch (e) {
      logger.e("Error initializing Hive: $e");
    }

    await Future.delayed(const Duration(seconds: 1));
    widget.onInitializationComplete();
  }

  // Register other services (use GetIt for dependency injection, etc.)
  void _registerServices() {
    final hiveService = HiveService();
    GetIt.instance.registerSingleton<HiveService>(hiveService);
    GetIt.instance.registerSingleton<NavigationService>(NavigationService());
    GetIt.instance.registerSingleton<EventProvider>(EventProvider());
  }
}
