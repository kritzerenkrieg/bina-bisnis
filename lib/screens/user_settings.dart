// ignore_for_file: use_build_context_synchronously, deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:buang_bijak/screens/landing_page.dart';
import 'package:buang_bijak/theme.dart';
import 'package:buang_bijak/widgets/button.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  UserSettingsState createState() => UserSettingsState();
}

class UserSettingsState extends State<UserSettings> {
  String username = ''; // Initialize username as an empty string
  String email = ''; // Initialize email as an empty string

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
          email = userDoc['email'] ??
              'user@gmail.com'; // Get email from Firebase Auth
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Periksa apakah user adalah admin
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          // Periksa nilai isAdmin
          final bool isAdmin = userDoc.data()?['isAdmin'] ?? false;

          // Arahkan berdasarkan status isAdmin
          if (isAdmin) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/dashboard', (route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }
        }
        return false; // Mencegah keluar dari aplikasi
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: white,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: black),
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                final userDoc = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .get();

                final bool isAdmin = userDoc.data()?['isAdmin'] ?? false;

                if (isAdmin) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/dashboard', (route) => false);
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                }
              }
            },
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              'Akun Saya',
              style: bold20.copyWith(color: black),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            // Centers the constrained content
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600, // Limit the maximum width to 600px
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 16.0, left: 16.0, right: 16.0),
                child: Column(
                  children: [
                    // User Info Card
                    Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Profile Picture
                            ClipOval(
                              child: Image.asset(
                                'assets/images/profile_picture.png',
                                width: 30, // Sesuaikan ukuran
                                height: 30,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                  Icons.person,
                                  size: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // User Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    username,
                                    style: bold14.copyWith(color: Colors.black),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    email,
                                    style: regular12,
                                  ),
                                ],
                              ),
                            ),
                            // Edit Icon
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.grey),
                              onPressed: () {
                                // Handle edit button press
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Divider(),
                    ),
                    // Account Options
                    ListTile(
                      leading: const Icon(Icons.location_on_outlined),
                      title: Text('Daftar Alamat', style: bold14),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.history),
                      title: Text('Riwayat Redeem', style: bold14),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.receipt_long),
                      title: Text('Riwayat Transaksi', style: bold14),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.payment),
                      title: Text('Metode Pembayaran', style: bold14),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.notifications_outlined),
                      title: Text('Notifikasi', style: bold14),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Divider(),
                    ),
                    // Information Section
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: Text('Panduan Layanan', style: bold14),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.help_outline),
                      title: Text('Pusat Bantuan', style: bold14),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.thumb_up_alt_outlined),
                      title: Text('Ulas Kami', style: bold14),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip_outlined),
                      title: Text('Kebijakan Privasi', style: bold14),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: Text('Syarat dan Ketentuan', style: bold14),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    // Logout Button
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Button(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Konfirmasi Keluar',
                                            style: bold16.copyWith(
                                                fontWeight: FontWeight.bold)),
                                        backgroundColor: white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        content: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Text(
                                            "Apakah kamu ingin keluar?",
                                            style: regular12,
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Tutup dialog
                                            },
                                            child: Text('Batal',
                                                style: regular14.copyWith(
                                                    color: Colors.black45)),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.of(context)
                                                  .pop(); // Tutup dialog
                                              await FirebaseAuth.instance
                                                  .signOut(); // Logout pengguna
                                              if (mounted) {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginScreen(),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Text('Yakin',
                                                style: regular14.copyWith(
                                                    color: Colors.red)),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                color: red,
                                text: 'Keluar'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
