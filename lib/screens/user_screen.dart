// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:buang_bijak/screens/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buang_bijak/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import '../widgets/navigation_buttons.dart';
import '../widgets/jadwal_card.dart';
import '../theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:buang_bijak/widgets/history_card.dart';
import 'package:buang_bijak/utils/date_helper.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  Future<List<Map<String, dynamic>>> _getUserPickups(
      {String? status1, String? status2}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    try {
      List<QuerySnapshot> querySnapshots = [];

      if (status1 != null) {
        querySnapshots.add(
          await FirebaseFirestore.instance
              .collection('ajukan_pickup')
              .where('user_id', isEqualTo: user.uid)
              .where('status', isEqualTo: status1)
              .orderBy('tanggal_pickup')
              .get(),
        );
      }

      if (status2 != null) {
        querySnapshots.add(
          await FirebaseFirestore.instance
              .collection('ajukan_pickup')
              .where('user_id', isEqualTo: user.uid)
              .where('status', isEqualTo: status2)
              .orderBy('tanggal_pickup')
              .get(),
        );
      }

      List<Map<String, dynamic>> pickups = querySnapshots
          .expand((snapshot) =>
              snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>))
          .toList();

      return pickups;
    } catch (e) {
      logger.e('Error fetching pickups', error: e);
      return [];
    }
  }

  Future<bool> _onWillPop(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        final isAdmin = userDoc['isAdmin'] ?? false;

        if (isAdmin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      } catch (e) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    } else {
      SystemNavigator.pop();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _onWillPop(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(200),
          child: HomeAppBar(),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  const NavigationButtons(),

                  const SizedBox(height: 28),

                  Row(
                    children: [
                      Image.asset('assets/icons/calendar.png',
                          width: 20, height: 20),
                      const SizedBox(width: 12),
                      Text('Jadwal Angkut Sampah Anda', style: bold16),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Jadwal Pickup Dinamis
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _getUserPickups(status1: 'Pending'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Error fetching Jadwal'));
                      }

                      List<Map<String, dynamic>> pickups = snapshot.data ?? [];

                      if (pickups.isEmpty) {
                        return Container(
                          width: double.infinity,
                          height: 80,
                          alignment: Alignment.center,
                          child: const Text('Data kosong',
                              textAlign: TextAlign.center),
                        );
                      }

                      return Column(
                        children: pickups.map((pickup) {
                          return Column(
                            children: [
                              JadwalCard(
                                time: pickup['waktu_pickup'],
                                date: formatPickupDate(
                                    (pickup['tanggal_pickup'] as Timestamp)
                                        .toDate()),
                                wasteType: pickup['jenis_sampah'],
                                address: pickup['lokasi_pickup'],
                                status: pickup['status'],
                                orderId: pickup['order_id'],
                                isRevised: pickup['isRevised'],
                                rejectedReason: pickup['rejectedReason'],
                              ),
                              const SizedBox(height: 8),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  const ImageBanner(),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Image.asset('assets/icons/clock.png',
                          width: 20, height: 20),
                      const SizedBox(width: 12),
                      Text('Histori Pickup', style: bold16),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // History Pickup Dinamis
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future:
                        _getUserPickups(status1: 'Success', status2: 'Cancel'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Error fetching History');
                      }

                      List pickups = snapshot.data ?? [];

                      if (pickups.isEmpty) {
                        return Container(
                          width: double.infinity,
                          height: 80,
                          alignment: Alignment.center,
                          child:
                              Text('Data kosong', textAlign: TextAlign.center),
                        );
                      }

                      return Column(
                        children: pickups.map((pickup) {
                          return Column(
                            children: [
                              HistoryCard(
                                time: pickup['waktu_pickup'],
                                date: formatPickupDate(
                                    pickup['tanggal_pickup'].toDate()),
                                wasteType: pickup['jenis_sampah'],
                                address: pickup['lokasi_pickup'],
                                status: pickup['status'],
                                orderId: pickup['order_id'],
                                isRevised: pickup['isRevised'],
                                rejectedReason: pickup['rejectedReason'],
                              ),
                              const SizedBox(height: 8),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),

            // Floating Navigation Bar
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  selectedItemColor: Colors.black,
                  unselectedItemColor: Colors.black38,
                  selectedLabelStyle: regular12,
                  unselectedLabelStyle: regular12,
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home_rounded), label: 'Beranda'),
                    // BottomNavigationBarItem(
                    //     icon: Icon(Icons.inbox), label: 'Pickup'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person), label: 'Profile'),
                  ],
                  onTap: (index) {
                    String routeName;
                    switch (index) {
                      case 0:
                        routeName = '/';
                        break;
                      // case 1:
                      //   routeName = '/ajukan-pickup';
                      //   break;
                      case 1:
                        routeName = '/profil-saya';
                        break;
                      default:
                        routeName = '/';
                    }
                    Navigator.pushReplacementNamed(context, routeName);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageBanner extends StatelessWidget {
  const ImageBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Track dan Kelola\nSampah Mu!', style: bold16),
                  SizedBox(height: 8),
                  Text('Lacak Sampah dan Dukung\nLingkungan Lebih Bersih.',
                      style: regular14),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: Image.asset(
                'assets/images/girl_with_green_shirt.png',
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
