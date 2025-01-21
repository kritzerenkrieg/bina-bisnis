import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> saveUserDetailsToFirestore({
  required String uid,
  required String username,
  required String fullName,
  required String email,
  required String address,
}) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

  await userRef.set({
    'username': username,
    'fullName': fullName,
    'email': email,
    'address': address,
    'createdAt': FieldValue.serverTimestamp(),
  });
}
