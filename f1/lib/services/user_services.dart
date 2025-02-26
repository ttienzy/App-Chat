import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lưu/thông tin user vào Firestore
  Future<void> saveUserToFirestore(User user) async {
    print('Saving user data for ${user}');
    try {
      final userData = {
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'phoneNumber': user.phoneNumber,
        'creationTime': user.metadata.creationTime,
        'lastSignInTime': user.metadata.lastSignInTime,
        'providers':
            user.providerData.map((provider) => provider.providerId).toList(),
      };

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userData, SetOptions(merge: true));

      print('User data saved successfully for ${user.uid}');
    } catch (e) {
      print('Error saving user data: $e');
      rethrow;
    }
  }

  // Lấy thông tin user từ Firestore
  Future<DocumentSnapshot> getUserData(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }
}
