import 'package:buang_bijak/utils/date_helper.dart';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/jadwal_card.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final Logger logger = Logger();

class LandingPickup extends StatelessWidget {
  const LandingPickup({super.key});

  Future<List<Map<String, dynamic>>> _getUserPickups(String status) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ajukan_pickup')
          .where('user_id', isEqualTo: user.uid)
          .where('status', isEqualTo: status)
          .orderBy('tanggal_pickup')
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      logger.e('Error fetching pickups', error: e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: black),
          onPressed: () {
            Navigator.pop(context); // Kembali ke layar sebelumnya
          },
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Text(
            'Jadwal Pickup',
            style: bold20.copyWith(color: black),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20.0, 16, 20.0, 6),
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset(
                'assets/images/truck-banner.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Bagian Jadwal Pickup
          Row(
            children: [
              Image.asset(
                'assets/icons/calendar.png',
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 12),
              Text('Jadwal Pickup Anda', style: bold16),
            ],
          ),

          const SizedBox(height: 16),

          // Jadwal Pickup
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _getUserPickups('Pending'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Error fetching Jadwal'));
              }

              List<Map<String, dynamic>> pickups = snapshot.data ?? [];

              if (pickups.isEmpty) {
                return Container(
                  width: double.infinity,
                  height: 80,
                  alignment: Alignment.center,
                  child: const Text('Data kosong', textAlign: TextAlign.center),
                );
              }

              return Column(
                children: pickups.map((pickup) {
                  return Column(
                    children: [
                      JadwalCard(
                        time: pickup['waktu_pickup'],
                        date: formatPickupDate(
                            (pickup['tanggal_pickup'] as Timestamp).toDate()),
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
        ],
      ),
    );
  }
}
