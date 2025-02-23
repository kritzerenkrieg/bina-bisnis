import 'package:buang_bijak/screens/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import '../theme.dart';
import '../widgets/jadwal_card.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/history_card.dart';
import '../utils/date_helper.dart';

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

      return querySnapshots
          .expand((snapshot) =>
              snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>))
          .toList();
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
            MaterialPageRoute(builder: (context) => const Dashboard()),
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Hai, Bibi!',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total asetmu',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Rp 0',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Total profit Rp 0 (▲ 0%)',
                      style: TextStyle(color: Colors.green),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              'Saldo Aktif',
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Rp 0',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Topup'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Tarik'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Rekomendasi Mitra UMKM Untukmu!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PT. Karya Ber',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text('Modal Pengolahan Tahu Kuning'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Chip(
                                  label: const Text('Crowdfunding'),
                                  backgroundColor: Colors.yellow,
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  children: const [
                                    Icon(Icons.star, color: Colors.orange),
                                    Text('4.5/5'),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('Plafond'),
                                    Text(
                                      'Rp 7.000.000',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('Bagi Hasil'),
                                    Text(
                                      '17%',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Ayo Modalin!'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black38,
          currentIndex: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.business), label: 'UMKM'),
            BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Blog'),
            BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Portfolio'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
          ],
          onTap: (index) {
            String routeName;
            switch (index) {
              case 0:
                routeName = '/';
                break;
              case 1:
                routeName = '/umkm';
                break;
              case 2:
                routeName = '/blog';
                break;
              case 3:
                routeName = '/portfolio';
                break;
              case 4:
                routeName = '/profil-saya';
                break;
              default:
                routeName = '/';
            }
            Navigator.pushReplacementNamed(context, routeName);
          },
        ),
      ),
    );
  }
}