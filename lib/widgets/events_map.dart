import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:event_hopper/models/event_model.dart';
import 'package:event_hopper/themes/app_theme.dart';
import 'package:event_hopper/widgets/app_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// Builds the map area for a list of events. The screens accept one so tests
/// can replace the Google Maps platform view, which cannot render there.
typedef EventsMapBuilder = Widget Function(
  BuildContext context,
  List<EventModel> events,
  EventModel? selected,
  ValueChanged<EventModel>? onSelect,
);

/// Google map with one pin per event. Tapping a pin reports the event.
class EventsMap extends StatefulWidget {
  final List<EventModel> events;
  final EventModel? selected;
  final ValueChanged<EventModel>? onSelect;

  /// A preview is a still map centered on the selected event.
  final bool preview;

  const EventsMap({
    super.key,
    required this.events,
    this.selected,
    this.onSelect,
    this.preview = false,
  });

  /// The Google Maps plugin only has Android and iOS implementations in this app.
  static bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  State<EventsMap> createState() => _EventsMapState();
}

class _EventsMapState extends State<EventsMap> {
  static const double _plumHue = 335;
  static const double _coralHue = 16;

  GoogleMapController? _mapController;

  @override
  void didUpdateWidget(EventsMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    final selected = widget.selected;
    if (selected != null && selected != oldWidget.selected) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(selected.googleMapsLocation),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!EventsMap.isSupported) {
      return ColoredBox(
        color: AppColors.neutralSoft,
        child: Center(
          child: widget.preview
              ? const Icon(Icons.map_outlined, color: AppColors.hint, size: 32)
              : StateMessage(
                  icon: Icons.map_outlined,
                  title: context.tr('map_unsupported_title'),
                  body: context.tr('map_unsupported_body'),
                ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final map = GoogleMap(
          initialCameraPosition: _initialCamera(constraints.biggest),
          markers: {
            for (final event in widget.events)
              Marker(
                markerId: MarkerId(event.title),
                position: event.googleMapsLocation,
                zIndex: event == widget.selected ? 1 : 0,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  event == widget.selected ? _coralHue : _plumHue,
                ),
                onTap: widget.onSelect == null
                    ? null
                    : () => widget.onSelect!(event),
              ),
          },
          liteModeEnabled:
              widget.preview && defaultTargetPlatform == TargetPlatform.android,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
        );
        return widget.preview ? AbsorbPointer(child: map) : map;
      },
    );
  }

  CameraPosition _initialCamera(Size size) {
    final selected = widget.selected;
    if (widget.preview && selected != null) {
      return CameraPosition(target: selected.googleMapsLocation, zoom: 14.0);
    }
    if (widget.events.isEmpty) {
      return const CameraPosition(target: LatLng(0, 0), zoom: 1);
    }

    final latitudes = widget.events.map((e) => e.googleMapsLocation.latitude);
    final longitudes = widget.events.map((e) => e.googleMapsLocation.longitude);
    final south = latitudes.reduce(math.min);
    final north = latitudes.reduce(math.max);
    final west = longitudes.reduce(math.min);
    final east = longitudes.reduce(math.max);

    return CameraPosition(
      target: LatLng((south + north) / 2, (west + east) / 2),
      zoom: _zoomToFit(size, south, north, west, east),
    );
  }

  // Zoom level at which the given bounds fit the map, leaving room for the
  // cards drawn over it. At zoom z the whole world is 256 * 2^z points wide.
  double _zoomToFit(
    Size size,
    double south,
    double north,
    double west,
    double east,
  ) {
    double mercator(double latitude) {
      final radians = latitude * math.pi / 180;
      return math.log(math.tan(math.pi / 4 + radians / 2));
    }

    final longitudeShare = (east - west) / 360;
    final latitudeShare = (mercator(north) - mercator(south)) / (2 * math.pi);
    double zoomFor(double points, double share) {
      if (share <= 0 || !points.isFinite || points <= 0) return 14;
      return math.log(points * 0.6 / (256 * share)) / math.ln2;
    }

    final zoom = math.min(
      zoomFor(size.width, longitudeShare),
      zoomFor(size.height, latitudeShare),
    );
    return zoom.clamp(1.0, 14.0);
  }
}

/// Opens the event's position in Google Maps, with a message when nothing can open it.
Future<void> openEventInGoogleMaps(
    BuildContext context, EventModel event) async {
  final messenger = ScaffoldMessenger.of(context);
  final failedMessage = context.tr('directions_failed');
  final location = event.googleMapsLocation;
  final uri = Uri.parse(
    'https://www.google.com/maps?q=${location.latitude},${location.longitude}',
  );

  var opened = false;
  try {
    opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    opened = false;
  }
  if (!opened) {
    messenger.showSnackBar(SnackBar(content: Text(failedMessage)));
  }
}
