// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:buang_bijak/screens/user_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import '../theme.dart';
import '../widgets/button.dart';
import '../widgets/pickup_status.dart';
import 'package:logger/logger.dart';
import 'update_pickup_screens.dart';

final log = Logger();
bool isLoading = false;

class DetailPickup extends StatefulWidget {
  const DetailPickup({
    super.key,
    required this.status,
    required this.time,
    required this.date,
    required this.wasteType,
    required this.address,
    required this.orderId,
    required this.isRevised,
    required this.rejectedReason,
  });

  final String status;
  final String time;
  final String date;
  final String wasteType;
  final String address;
  final String orderId;
  final bool isRevised;
  final String? rejectedReason;

  @override
  _DetailPickupState createState() => _DetailPickupState();
}

class _DetailPickupState extends State<DetailPickup> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    String message;

    if (widget.status == 'Success') {
      message = 'Sampahmu telah dipickup!';
    } else if (widget.status == 'Cancel') {
      message = 'Pickup telah dibatalkan';
    } else {
      message = 'Kolektor sedang dalam perjalanan!';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: black),
          onPressed: () {
            Navigator.pop(context); // Goes back to the previous screen
          },
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Text(
            'Detail Pickup',
            style: bold20.copyWith(color: black),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: ListView(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: 0,
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/truck-banner.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        '${widget.date}, ${widget.time}',
                        style: bold16,
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        widget.wasteType,
                        style: regular14,
                      ),
                      const SizedBox(height: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lokasi Pickup',
                            style: bold16,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            widget.address,
                            style: regular14,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      PickupStatus(
                        status: widget.status,
                        isRevised: widget.isRevised,
                      ),
                      const SizedBox(height: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message,
                            style: bold16,
                          ),
                          if (widget.rejectedReason != null &&
                              widget.rejectedReason!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4.0),
                                Text(
                                  'Alasan: ${widget.rejectedReason!}',
                                  style: regular14,
                                ),
                              ],
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset('assets/images/maps.png',
                                  height: 200, fit: BoxFit.cover),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Order ID:',
                        style: regular10,
                      ),
                      Text(
                        widget.orderId,
                        style: regular10,
                      ),
                      const SizedBox(height: 20.0),
                      if (widget.status != 'Success' &&
                          widget.status != 'Cancel')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (!widget
                                .isRevised) // Menghapus button Reschedule jika isRevised true
                              Expanded(
                                child: Button(
                                  text: 'Reschedule',
                                  color: white,
                                  borderColor: grey3,
                                  textColor: black,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          backgroundColor: white,
                                          contentPadding: EdgeInsets.all(24),
                                          title: Text(
                                              'Konfirmasi Revisi Pickup',
                                              style: bold16.copyWith(
                                                  fontWeight: FontWeight.bold)),
                                          content: RichText(
                                            text: TextSpan(
                                              style: regular14.copyWith(
                                                  color: Colors.black),
                                              children: [
                                                TextSpan(
                                                    text:
                                                        'Mengubah jadwal pickup '),
                                                TextSpan(
                                                  text: 'hanya bisa 1x',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                    text:
                                                        ' saja. Pastikan data benar-benar ingin direvisi.'),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: Text('Batal',
                                                  style: regular14.copyWith(
                                                      color: Colors.black45)),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UpdatePickupPage(
                                                            orderId:
                                                                widget.orderId),
                                                  ),
                                                );
                                              },
                                              child: Text('Revisi',  style: regular14.copyWith(color: Colors.black)),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            if (!widget.isRevised) const SizedBox(width: 16.0),
                            Expanded(
                              child: Button(
                                text: 'Batalkan Pickup',
                                color: red,
                                textColor: white,
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      backgroundColor: white,
                                      contentPadding: EdgeInsets.all(24),
                                      title: Text('Konfirmasi Penghapusan',
                                          style: bold16.copyWith(
                                              fontWeight: FontWeight.bold)),
                                      content: RichText(
                                        text: TextSpan(
                                          style: regular14.copyWith(
                                              color: Colors.black),
                                          children: [
                                            TextSpan(
                                                text: 'Membatalkan berarti '),
                                            TextSpan(
                                              text: 'menghapus/membatalkan',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(text: ' order dan'),
                                            TextSpan(
                                              text: ' tidak akan ada',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                                text:
                                                    ' dalam history. Aksi ini '),
                                            TextSpan(
                                              text: 'tidak dapat dipulihkan',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(text: '.'),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text('Batal',
                                              style: regular14.copyWith(
                                                  color: black)),
                                        ),
                                        TextButton(
                                          onPressed: isLoading
                                              ? null
                                              : () async {
                                                  setState(() {
                                                    isLoading = true;
                                                  });

                                                  try {
                                                    final user = FirebaseAuth
                                                        .instance.currentUser;

                                                    if (user != null) {
                                                      log.d(
                                                          'Trying to delete order ID: ${widget.orderId}');

                                                      // Pastikan path benar
                                                      try {
                                                        // Cari dokumen berdasarkan field order_id
                                                        QuerySnapshot
                                                            querySnapshot =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'ajukan_pickup')
                                                                .where(
                                                                    'order_id',
                                                                    isEqualTo:
                                                                        widget
                                                                            .orderId)
                                                                .get();

                                                        if (querySnapshot
                                                            .docs.isNotEmpty) {
                                                          for (var doc
                                                              in querySnapshot
                                                                  .docs) {
                                                            await doc.reference
                                                                .delete();
                                                            log.d(
                                                                'Order ID ${widget.orderId} deleted successfully');
                                                          }
                                                        } else {
                                                          log.d(
                                                              'No document found with order_id ${widget.orderId}');
                                                        }
                                                      } catch (e) {
                                                        log.e(
                                                            'Failed to delete order ID ${widget.orderId}',
                                                            error: e);
                                                      }

                                                      log.d(
                                                          'Order ID ${widget.orderId} deleted successfully');

                                                      Navigator.of(context)
                                                          .pop(true);

                                                      Navigator.of(context)
                                                          .pushAndRemoveUntil(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                UserScreen()),
                                                        (route) => false,
                                                      );

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            'Order ID ${widget.orderId} telah berhasil dihapus',
                                                            style: regular14
                                                                .copyWith(
                                                                    color:
                                                                        white),
                                                          ),
                                                          backgroundColor: red,
                                                          duration:
                                                              const Duration(
                                                                  seconds: 3),
                                                        ),
                                                      );
                                                    }
                                                  } catch (e) {
                                                    log.e(
                                                        'Failed to delete pickup order.',
                                                        error: e);
                                                  } finally {
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                  }
                                                },
                                          child: isLoading
                                              ? Row(
                                                  children: [
                                                    CircularProgressIndicator(
                                                      color: red,
                                                      strokeWidth: 2,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text('Yakin', style: bold14.copyWith(color: red)),
                                                  ],
                                                )
                                              : Text('Yakin', style: bold14.copyWith(color: red)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
