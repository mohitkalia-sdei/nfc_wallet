import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nfc_wallet/models/profiles_info.dart';
import 'package:nfc_wallet/models/region.dart';
import 'package:nfc_wallet/models/user.dart';
import 'package:nfc_wallet/models/vehicle_model.dart';
import 'package:nfc_wallet/models/vendor.dart';
import 'package:nfc_wallet/service/location_service.dart';

final localeProvider = StateProvider<Locale>((ref) {
  return const Locale('en');
});
final userProvider = StateProvider<User?>((ref) {
  return null;
});
final vehicleProvider = StateProvider<Vehicle?>((ref) {
  return null;
});

final profileinfoProvider = StateProvider<ProfileInformation?>((ref) {
  return null;
});

final locationProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {};
});

final regionProvider = StateProvider<Region>((ref) {
  return Region('', '', 0, {});
});

final vendorProvider = StateProvider<Vendor?>((ref) {
  return null;
});

final locationsProvider = StreamProvider<Position>((ref) async* {
  final locationService = LocationsService();
  await locationService.checkLocationPermissions();
  yield* locationService.locationStream;
});
