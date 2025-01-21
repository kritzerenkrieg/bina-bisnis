import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:buang_bijak/theme.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  HomeAppBarState createState() => HomeAppBarState();
}

class HomeAppBarState extends State<HomeAppBar> {
  String username = ''; // Initialize username as an empty string

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fetch user data from Firestore
  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          username =
              userDoc['username'] ?? 'Pengguna'; // Get username from Firestore
        });
      }
    }
  }

  // Function to determine greeting based on the time of day
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi';
    } else if (hour < 18) {
      return 'Selamat Siang';
    } else {
      return 'Selamat Malam';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 224,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFCCE400),
            Color(0xFF68ACB4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          // Mascot image
          Positioned(
            right: 12,
            bottom: -20,
            child: Image.asset(
              'assets/images/hero_mascot.png',
              height: 200,
            ),
          ),
          // Header content
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 16),
                username.isEmpty
                    ? const CircularProgressIndicator() // Show loading if username is not yet loaded
                    : Text(
                        '${getGreeting()}\n$username!',
                        style: bold20.copyWith(
                          fontSize: 24,
                          shadows: [
                            Shadow(
                              offset: const Offset(1, 1),
                              color: Colors.white.withOpacity(1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Telusuri disini',
                    hintStyle: regular14,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0), // Adjust padding for the icon
                      child: Icon(Icons.search), // Icon to be displayed
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8, // Adjust vertical padding for text
                      horizontal: 16, // Adjust horizontal padding for text
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
