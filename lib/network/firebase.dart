import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/modeluser.dart';

class FirestoreHelper {
  static Stream<List<UserModel>>? read(String id)  {
     FirebaseFirestore.instance.collection("users").doc(id).snapshots();

  }
}
