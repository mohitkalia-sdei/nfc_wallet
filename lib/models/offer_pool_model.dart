import 'package:cloud_firestore/cloud_firestore.dart';

class PassengerOfferPool {
  final String? id;
  final Location pickupLocation;
  final Location dropoffLocation;
  final Timestamp dateTime; 
  final String selectedSeat;
  final int pricePerSeat;
  final String user;

  PassengerOfferPool({
    this.id,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.dateTime,
    required this.selectedSeat,
    required this.pricePerSeat,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return {
      'pickupLocation': pickupLocation.toMap(),
      'dropoffLocation': dropoffLocation.toMap(),
      'dateTime': dateTime,
      'selectedSeat': selectedSeat,
      'pricePerSeat': pricePerSeat,
      'user': user,
    };
  }

  factory PassengerOfferPool.fromMap(Map<String, dynamic> map) {
    return PassengerOfferPool(
      id: map['id'] ?? '',
      pickupLocation: Location.fromMap(map['pickupLocation']),
      dropoffLocation: Location.fromMap(map['dropoffLocation']),
      dateTime: map['dateTime'], 
      selectedSeat: map['selectedSeat'],
      pricePerSeat: map['pricePerSeat'], 
      user: map['user'],
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
