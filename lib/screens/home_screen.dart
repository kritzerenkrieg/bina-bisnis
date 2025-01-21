import 'package:flutter/material.dart';
import 'package:buang_bijak/screens/user_screen.dart';
import 'package:buang_bijak/screens/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required bool isAdmin});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data!.exists) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final bool isAdmin = userData['isAdmin'] ?? false;

          return isAdmin ? const Dashboard() : const UserScreen();
        }

        return const Scaffold(
          body: Center(child: Text('Gagal memuat data pengguna')),
        );
      },
    );
  }
}
