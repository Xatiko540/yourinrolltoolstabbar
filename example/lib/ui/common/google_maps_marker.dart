import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yourinrolltoolstabbar_example/assets.dart';

Marker getMapsMarker(LatLng position) => Marker(
      markerId: MarkerId('0'),
      position: position,
      icon: AppBitmaps.mapMarker,
      anchor: Offset(.5, .7),
    );
