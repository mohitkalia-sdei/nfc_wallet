import 'package:cloud_firestore/cloud_firestore.dart';

class PassengerFindPool {
  final String? id;
  final Location pickupLocation;
  final Location dropoffLocation;
  final Timestamp dateTime; 
  final String selectedSeat;
  final String user;
  final String? acceptedByDriver;
  final bool? pending;

  PassengerFindPool({
    this.id,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.dateTime,
    required this.selectedSeat,
    required this.user,
    this.acceptedByDriver,
    this.pending,
  });

  Map<String, dynamic> toMap() {
    return {
      'pickupLocation': pickupLocation.toMap(),
      'dropoffLocation': dropoffLocation.toMap(),
      'dateTime': dateTime,
      'selectedSeat': selectedSeat,
      'user': user,
      'acceptedByDriver': acceptedByDriver,
      'pending': pending,
    };
  }

  factory PassengerFindPool.fromMap(Map<String, dynamic> map) {
    return PassengerFindPool(
      id: map['id'] ?? '',
      pickupLocation: Location.fromMap(map['pickupLocation']),
      dropoffLocation: Location.fromMap(map['dropoffLocation']),
      dateTime: map['dateTime'], 
      selectedSeat: map['selectedSeat'],
      user: map['user'],
      acceptedByDriver: map['acceptedByDriver'],
      pending: map['pending'],
    );
  }
}

class Location {
  final String address;
  final double latitude;
  final double longitude;

  Location({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      address: map['address'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
