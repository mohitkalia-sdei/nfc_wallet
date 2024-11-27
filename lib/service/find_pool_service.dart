import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_wallet/models/find_pool_model.dart';
import 'package:nfc_wallet/shared/shared_states.dart';
import 'package:nfc_wallet/utils/contants.dart';

class FindPoolService {
  static final collection = collections.findPool;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<void> createFindPool(PassengerFindPool pool) async {
    try {
      await firestore.collection(collection).doc(pool.id).set(pool.toMap());
    } catch (e) {
      throw Exception('Failed to create FindPool entry');
    }
  }

  static final findingStreams = StreamProvider<List<PassengerFindPool>>((ref) {
    final user = ref.read(userProvider)!;
    return firestore.collection(collection).where('user', isEqualTo: user.id).snapshots().map(
          (event) => event.docs.map((e) {
            var data = e.data();
            data['id'] = e.id;
            return PassengerFindPool.fromMap(data);
          }).toList(),
        );
  });
}
