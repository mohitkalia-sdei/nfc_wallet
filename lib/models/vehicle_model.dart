import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nfc_wallet/models/user.dart';

class Vehicle {
  final String vehicleType;
  final String vehicleName;
  final String vehicleRegNumber;
  final int? pricePerSeat;
  final String facilities;
  final String instructions;
  final String userId;
  final Timestamp createdOn;

  Vehicle({
    required this.vehicleType,
    required this.vehicleName,
    required this.vehicleRegNumber,
    required this.pricePerSeat,
    required this.facilities,
    required this.instructions,
    required this.userId,
    required this.createdOn,
  });

  factory Vehicle.fromJSON(Map<String, dynamic> map) {
    return Vehicle(
      vehicleType: map['vehicleType'] ?? '',
      vehicleName: map['vehicleName'] ?? '',
      vehicleRegNumber: map['vehicleRegNumber'] ?? '',
      pricePerSeat: map['pricePerSeat'] != null ? int.tryParse(map['pricePerSeat'].toString()) : null,
      facilities: map['facilities'] ?? '',
      instructions: map['instructions'] ?? '',
      userId: map['userId'] ?? '',
      createdOn: map['createdOn'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vehicleType': vehicleType,
      'vehicleName': vehicleName,
      'vehicleRegNumber': vehicleRegNumber,
      'pricePerSeat': pricePerSeat,
      'facilities': facilities,
      'instructions': instructions,
      'userId': userId,
      'createdOn': createdOn,
    };
  }
}

class UserVehicle {
  final User? user;
  final Vehicle userVehicle;
  UserVehicle({required this.user, required this.userVehicle});
}
