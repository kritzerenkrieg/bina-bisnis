import 'package:buang_bijak/utils/date_helper.dart';
import 'package:flutter/material.dart';
import 'package:buang_bijak/widgets/history_card.dart';
import '../theme.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final Logger logger = Logger();

class HistoryPickup extends StatelessWidget {
  const HistoryPickup({super.key});

  Future<Map<String, List<Map<String, dynamic>>>>
      _getUserPickupsMultipleStatuses(List<String> statuses) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    try {
      Map<String, List<Map<String, dynamic>>> pickupsByStatus = {};

      for (String status in statuses) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('ajukan_pickup')
            .where('user_id', isEqualTo: user.uid)
            .where('status', isEqualTo: status)
            .orderBy('tanggal_pickup')
            .get();

        pickupsByStatus[status] = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      }

      return pickupsByStatus;
    } catch (e) {
      logger.e('Error fetching pickups', error: e);
      return {};
    }
  }

  Widget _buildPickupHistorySection() {
    final List<String> statuses = ['Success', 'Cancel'];

    return FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
      future: _getUserPickupsMultipleStatuses(statuses),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Text('Error fetching History');
        }

        Map<String, List<Map<String, dynamic>>> pickupsByStatus =
            snapshot.data ?? {};

        return Column(
          children: statuses.expand((status) {
            List<Map<String, dynamic>> pickups = pickupsByStatus[status] ?? [];

            if (pickups.isEmpty) {
              return [
                const SizedBox(height: 0),
              ];
            }

            return pickups.map((pickup) {
              return Column(
                children: [
                  HistoryCard(
                    time: pickup['waktu_pickup'],
                    date: formatPickupDate(pickup['tanggal_pickup'].toDate()),
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
            }).toList();
          }).toList(),
        );
      },
    );
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
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Text(
            'History Pickup',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/truck-banner.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Image.asset('assets/icons/clock.png', width: 20, height: 20),
              const SizedBox(width: 12),
              Text('Histori Pickup', style: bold16),
            ],
          ),
          const SizedBox(height: 16),
          _buildPickupHistorySection(),
        ],
      ),
    );
  }
}
