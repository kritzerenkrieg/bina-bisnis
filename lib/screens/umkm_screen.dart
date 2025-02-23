import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class UMKMScreen extends StatelessWidget {
  const UMKMScreen({super.key});

  Future<List<Map<String, dynamic>>> _getUMKMList() async {
    try {
      final querySnapshot =
      await FirebaseFirestore.instance.collection('umkm-list').get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      logger.e('Error fetching UMKM list', error: e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'UMKM',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Jawa Timur',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.filter_list, color: Colors.black),
                      SizedBox(width: 5),
                      Text(
                        'Filter',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getUMKMList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Tidak ada data UMKM'));
                }
                final umkmList = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: umkmList.length,
                  itemBuilder: (context, index) {
                    final umkm = umkmList[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  umkm['nama'] ?? 'Nama UMKM',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text('Detail'),
                                ),
                              ],
                            ),
                            Text(umkm['deskripsi'] ?? 'Deskripsi'),
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
                                  children: [
                                    const Text('Plafond'),
                                    Text(
                                      'Rp ${umkm['plafond']}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Bagi Hasil'),
                                    Text(
                                      '${umkm['bagi_hasil']}%',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black38,
        currentIndex: 1,
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
    );
  }
}
