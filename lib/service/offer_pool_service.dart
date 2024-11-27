import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_wallet/models/offer_pool_model.dart';
import 'package:nfc_wallet/shared/shared_states.dart';
import 'package:nfc_wallet/utils/contants.dart';

class OfferPoolService {
  static final collection = collections.offerpool;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<void> createFindPool(PassengerOfferPool pool) async {
    try {
      await firestore.collection(collection).doc(pool.id).set(pool.toMap());
    } catch (e) {
      throw Exception('Failed to create FindPool entry');
    }
  }

  static final offeringStreams = StreamProvider<List<PassengerOfferPool>>((ref) {
    final user = ref.read(userProvider)!;
    return firestore.collection(collection).where('user', isEqualTo: user.id).snapshots().map(
          (event) => event.docs.map((e) {
            var data = e.data();
            data['id'] = e.id;
            return PassengerOfferPool.fromMap(data);
          }).toList(),
        );
  });
}
