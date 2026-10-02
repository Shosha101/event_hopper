import 'package:event_hopper/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';

import '../Adapters/lating_adapter.dart';
import '../services/hive_service.dart';
import '../services/navigation_services.dart';
import '../themes/app_theme.dart';

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
    // Runs before the app widget exists, so there is no theme or text direction yet
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: AppColors.background,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // The logo image carries the app name
              Image.asset('assets/images/logo.png', width: 250),
              const SizedBox(height: 36),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.primary,
                ),
              ),
            ],
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
      await Hive.initFlutter(); // Initialize Hive first
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
