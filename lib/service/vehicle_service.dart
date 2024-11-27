import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_wallet/models/vehicle_model.dart';
import 'package:nfc_wallet/shared/shared_states.dart';
import 'package:nfc_wallet/utils/contants.dart';

class VehicleService {
  static final collection = collections.vehicle;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveOrUpdateVehicle(Vehicle data, WidgetRef ref) async {
    final user = ref.read(userProvider)!;
    final userId = user.phoneNumber;
    try {
      final existingVehicle = await _firestore.collection(collection).where('userId', isEqualTo: userId).get();
      if (existingVehicle.docs.isNotEmpty) {
        final docId = existingVehicle.docs.first.id;
        await _firestore.collection(collection).doc(docId).update(data.toMap());
      } else {
        await _firestore.collection(collection).doc(userId).set(data.toMap()..['userId'] = userId);
      }
      ref.read(vehicleProvider.notifier).state = data;
    } catch (e) {
      throw Exception("Failed to save vehicle data.");
    }
  }

  Future<Vehicle?> getVehicleData(String userId) async {
    final vehicleData = await _firestore.collection(collection).where('userId', isEqualTo: userId).get();
    if (vehicleData.docs.isNotEmpty) {
      return Vehicle.fromJSON(vehicleData.docs.first.data());
    }
    return null;
  }

  static final vehicleStream = StreamProvider.family<Vehicle?, String>((ref, phone) {
    return FirebaseFirestore.instance.collection(collection).doc(phone).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        data['id'] = snapshot.id;
        return Vehicle.fromJSON(data);
      } else {
        return null;
      }
    });
  });
}
