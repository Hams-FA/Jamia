import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/user_model.dart';

//change this to id
class FirestoreHelper {
  static Stream<List<UserModel>> readFromUsers(String? email) {
    final userFriends = FirebaseFirestore.instance
        .collection("users")
        .doc(email)
        .collection('friends');
    return userFriends.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }
}
