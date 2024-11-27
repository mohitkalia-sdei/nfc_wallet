import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_wallet/models/profile.dart';
import 'package:nfc_wallet/utils/contants.dart';

class ProfileServices {
  static final collection = collections.profiles;
  static final fireStore = FirebaseFirestore.instance;

  static final profilesStream = StreamProvider<List<Profile>>((ref) {
    return fireStore.collection(collection).snapshots().map(
          (event) => event.docs.map((e) {
            var data = e.data();
            data['id'] = e.id;
            return Profile.fromJson(data);
          }).toList(),
        );
  });
}
