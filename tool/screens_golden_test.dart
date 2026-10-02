// Renders the redesigned screens off-screen with the app's own demo events, in Arabic and English.
// Run: flutter test --update-goldens tool/screens_golden_test.dart  (PNGs land in tool/shots/)
import 'dart:io';
import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:event_hopper/Adapters/lating_adapter.dart';
import 'package:event_hopper/models/event_model.dart';
import 'package:event_hopper/providers/event_provider.dart';
import 'package:event_hopper/screens/event_details_screen.dart';
import 'package:event_hopper/screens/main_screen.dart';
import 'package:event_hopper/screens/splash_screen.dart';
import 'package:event_hopper/services/navigation_services.dart';
import 'package:event_hopper/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakePathProvider extends PathProviderPlatform {
  FakePathProvider(this.path);
  final String path;
  @override
  Future<String?> getApplicationDocumentsPath() async => path;
}

/// Stands in for the Google map, which cannot render in a widget test: a flat
/// panel with a faint grid and one pin per event at its relative position.
Widget mapPlaceholder(
  BuildContext context,
  List<EventModel> events,
  EventModel? selected,
  ValueChanged<EventModel>? onSelect,
) {
  final longitudes = events.map((e) => e.googleMapsLocation.longitude);
  final latitudes = events.map((e) => e.googleMapsLocation.latitude);
  final west = longitudes.reduce(math.min), east = longitudes.reduce(math.max);
  final south = latitudes.reduce(math.min), north = latitudes.reduce(math.max);

  return LayoutBuilder(
    builder: (context, constraints) {
      final size = constraints.biggest;
      Offset place(LatLng position) {
        final x = east == west ? 0.5 : (position.longitude - west) / (east - west);
        final y = north == south ? 0.5 : (north - position.latitude) / (north - south);
        return Offset(size.width * (0.14 + 0.72 * x), size.height * (0.32 + 0.24 * y));
      }

      return Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: GridPainter())),
          // The selected pin goes last so it is drawn on top
          for (final event in [...events.where((e) => e != selected), if (selected != null) selected])
            Positioned(
              left: place(event.googleMapsLocation).dx - 20,
              top: place(event.googleMapsLocation).dy - 40,
              child: Icon(
                Icons.location_on,
                size: 40,
                color: event == selected ? AppColors.accent : AppColors.primary,
              ),
            ),
        ],
      );
    },
  );
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFF1EEF0));
    final line = Paint()
      ..color = const Color(0xFFE3DEE1)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 48) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }
    for (double y = 0; y < size.height; y += 48) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => false;
}

Future<void> loadFonts() async {
  Future<ByteData> file(String path) async => ByteData.view((await File(path).readAsBytes()).buffer);
  final plex = FontLoader(AppTheme.fontFamily);
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    plex.addFont(file('assets/fonts/IBMPlexSansArabic-$weight.ttf'));
  }
  await plex.load();
  final sdk = File(Platform.resolvedExecutable).parent.parent.parent.parent.path;
  await (FontLoader('MaterialIcons')..addFont(file('$sdk/artifacts/material_fonts/materialicons-regular.otf'))).load();
}

// Asset photos decode asynchronously, so they are loaded for real before the frame is captured.
Future<void> showImages(WidgetTester tester) async {
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate()) {
      await precacheImage((element.widget as Image).image, element);
    }
  });
  await tester.pumpAndSettle();
}

void main() {
  late Directory hiveDir;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
    Logger.level = Level.nothing;
    await EasyLocalization.ensureInitialized();
    await loadFonts();

    hiveDir = await Directory.systemTemp.createTemp('event_hopper_shots');
    PathProviderPlatform.instance = FakePathProvider(hiveDir.path);
    Hive.init(hiveDir.path);
    Hive.registerAdapter(EventModelAdapter());
    Hive.registerAdapter(LatLngAdapter());
  });

  tearDownAll(() async {
    await Hive.close();
    await hiveDir.delete(recursive: true);
  });

  void usePhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    tester.view.padding = const FakeViewPadding(top: 88);
    tester.view.viewPadding = const FakeViewPadding(top: 88);
    addTearDown(tester.view.reset);
  }

  // Starts from an empty Hive store, loads the events the way the app does and saves
  // the events at [favorites], then shows [home] inside the app's own wrappers.
  Future<void> pumpApp(
    WidgetTester tester,
    String lang,
    Widget Function(List<EventModel> events) home, {
    List<int> favorites = const [0, 3, 4],
  }) async {
    usePhone(tester);

    final getIt = GetIt.instance;
    await getIt.reset();
    getIt.registerSingleton<NavigationService>(NavigationService());
    final provider = EventProvider();

    await tester.runAsync(() async {
      await Hive.deleteFromDisk();
      await provider.getEvent();
      for (final index in favorites) {
        await provider.toggleFavorite(provider.events[index]);
      }

      await tester.pumpWidget(
        EasyLocalization(
          key: UniqueKey(),
          supportedLocales: const [Locale('ar'), Locale('en')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          startLocale: Locale(lang),
          saveLocale: false,
          ignorePluralRules: false,
          child: ChangeNotifierProvider.value(
            value: provider,
            child: Builder(
              builder: (context) => MaterialApp(
                navigatorKey: NavigationService.navigatorKey,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                home: home(provider.events),
              ),
            ),
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
    await tester.pumpAndSettle();
    await showImages(tester);
  }

  Future<void> openTab(WidgetTester tester, IconData icon) async {
    await tester.tap(find.descendant(of: find.byType(NavigationBar), matching: find.byIcon(icon)));
    await tester.pumpAndSettle();
    await showImages(tester);
  }

  testWidgets('splash', (tester) async {
    usePhone(tester);
    await tester.runAsync(() async {
      await tester.pumpWidget(SplashPage(onInitializationComplete: () {}));
      // Lets the page finish its own start-up work and its one-second wait
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      final image = find.byType(Image).evaluate().single;
      await precacheImage((image.widget as Image).image, image);
    });
    // The spinner starts as a dot; a little time gives it a visible arc
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await expectLater(find.byType(SplashPage), matchesGoldenFile('shots/splash.png'));
  });

  for (final lang in ['ar', 'en']) {
    testWidgets('$lang home', (tester) async {
      debugDisableShadows = false;
      await pumpApp(tester, lang, (_) => const MainScreen(mapBuilder: mapPlaceholder));
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('shots/$lang-01-home.png'));
      debugDisableShadows = true;
    });

    testWidgets('$lang event details', (tester) async {
      debugDisableShadows = false;
      await pumpApp(
        tester,
        lang,
        (events) => EventDetailsScreen(event: events[3], mapBuilder: mapPlaceholder),
      );
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('shots/$lang-02-details.png'));

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -700));
      await tester.pumpAndSettle();
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('shots/$lang-03-details-map.png'));
      debugDisableShadows = true;
    });

    testWidgets('$lang map', (tester) async {
      debugDisableShadows = false;
      await pumpApp(tester, lang, (_) => const MainScreen(mapBuilder: mapPlaceholder));
      await openTab(tester, Icons.map_outlined);
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('shots/$lang-04-map.png'));
      debugDisableShadows = true;
    });

    testWidgets('$lang favorites', (tester) async {
      debugDisableShadows = false;
      await pumpApp(tester, lang, (_) => const MainScreen(mapBuilder: mapPlaceholder));
      await openTab(tester, Icons.favorite_border);
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('shots/$lang-05-favorites.png'));
      debugDisableShadows = true;
    });

    testWidgets('$lang empty favorites', (tester) async {
      debugDisableShadows = false;
      await pumpApp(
        tester,
        lang,
        (_) => const MainScreen(mapBuilder: mapPlaceholder),
        favorites: const [],
      );
      await openTab(tester, Icons.favorite_border);
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('shots/$lang-06-favorites-empty.png'));
      debugDisableShadows = true;
    });

    testWidgets('$lang profile', (tester) async {
      debugDisableShadows = false;
      await pumpApp(tester, lang, (_) => const MainScreen(mapBuilder: mapPlaceholder));
      await openTab(tester, Icons.person_outline);
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('shots/$lang-07-profile.png'));
      debugDisableShadows = true;
    });
  }
}
