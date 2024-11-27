import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_wallet/models/drivers.dart';
import 'package:nfc_wallet/service/driver_service.dart';

// Instantiate the DriverService
final driverServiceProvider = Provider((ref) => DriverService());

// StreamProvider for all drivers
final driversStreamProvider = StreamProvider<List<Driver>>((ref) {
  final driverService = ref.watch(driverServiceProvider);
  return driverService.getDriversStream();
});

// StreamProvider for a single driver by ID
final driverStreamProvider = StreamProvider.family<Driver?, String>((ref, driverId) {
  final driverService = ref.watch(driverServiceProvider);
  return driverService.getDriverStreamById(driverId);
});
